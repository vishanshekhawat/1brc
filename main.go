package main

import (
	"bytes"
	"errors"
	"fmt"
	"io"
	"math"
	"os"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"time"
)

func main() {

	startTime := time.Now()
	defer func() {
		fmt.Printf("%v\n", time.Since(startTime))
	}()

	cityData := readFile()
	result := []string{}

	var mu sync.Mutex
	updateResult := func(res string) {
		fmt.Println(res)
		mu.Lock()
		defer mu.Unlock()
		result = append(result, res)
	}

	for city, temps := range cityData {
		go func(city string, temps []float64) {
			fmt.Println(city)
			var min, max, avg float64
			for i, temp := range temps {
				if i == 0 {
					min = temp
					max = temp
				}
				avg += temp
				if min > temp {
					min = temp
				}
				if max < temp {
					max = temp
				}
			}

			avg = avg / float64(len(temps))
			// fmt.Println(avg)
			avg = math.Ceil(avg*10) / 10

			updateResult(fmt.Sprintf("%s=%.1f/%.1f/%.1f", city, min, max, avg))
		}(city, temps)
	}

	fmt.Println(strings.Join(result, ", "))
}

func readFile() map[string][]float64 {

	fileName := "./files/cities_temperatures.csv"
	file, err := os.Open(fileName)
	if err != nil {
		panic(err)
	}

	chunkStream := make(chan []byte, 8)
	resultStream := make(chan []string, 100)
	var wg sync.WaitGroup
	// read from chunk stream
	// spawn workers to consume (process) file chunks read
	for i := 0; i < runtime.NumCPU()-1; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for chunk := range chunkStream {
				processChunk(chunk, resultStream)
			}
		}()
	}

	citiesList := make(map[string][]float64)

	// 20mb buffer size
	chunkSize := 4 * 1024 * 1024

	// spawn a goroutine to read file in chunks and send it to the chunk channel for further processing
	go func() {
		buf := make([]byte, chunkSize)
		leftover := make([]byte, 0, chunkSize)
		for {
			readTotal, err := file.Read(buf)
			if err != nil {
				if errors.Is(err, io.EOF) {
					break
				}
				panic(err)
			}
			buf = buf[:readTotal]

			toSend := make([]byte, readTotal)
			copy(toSend, buf)

			lastNewLineIndex := bytes.LastIndex(buf, []byte{'\n'})

			toSend = append(leftover, buf[:lastNewLineIndex+1]...)
			leftover = make([]byte, len(buf[lastNewLineIndex+1:]))
			copy(leftover, buf[lastNewLineIndex+1:])

			chunkStream <- toSend

		}
		close(chunkStream)

	}()

	go func() {
		// wait for all chunks to be proccessed before closing the result stream
		wg.Wait()
		close(resultStream)
	}()

	for t := range resultStream {
		for _, text := range t {

			index := strings.Index(text, ",")
			if index == -1 {
				continue
			}
			cityName := text[:index]
			temp := text[index+2:]

			// change to float64
			tem, err := strconv.ParseFloat(temp, 64)
			if err != nil {
				fmt.Println(text)
				panic(err)
			}

			if val, ok := citiesList[cityName]; ok {
				citiesList[cityName] = append(val, tem)
			} else {
				citiesList[cityName] = []float64{tem}
			}
		}
	}

	return citiesList
}

func processChunk(buf []byte, resultStream chan<- []string) {
	var count int
	var stringsBuilder strings.Builder
	toSend := make([]string, 100)

	for _, char := range buf {
		if char == '\n' {
			if stringsBuilder.Len() != 0 {
				toSend[count] = stringsBuilder.String()
				stringsBuilder.Reset()
				count++

				if count == 100 {
					count = 0
					localCopy := make([]string, 100)
					copy(localCopy, toSend)
					resultStream <- localCopy
				}
			}
		} else {
			stringsBuilder.WriteByte(char)
		}
	}
	if count != 0 {
		resultStream <- toSend[:count]
	}
}
