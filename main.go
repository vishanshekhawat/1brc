package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
	"time"
)

func main() {

	startTime := time.Now()
	defer func() {
		fmt.Printf("%v\n", time.Since(startTime))
	}()

	cityData := readFile()
	result := []string{}

	for city, temps := range cityData {
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

		result = append(result, fmt.Sprintf("%s=%.1f/%.1f/%.1f", city, min, max, avg))
	}

	fmt.Println(strings.Join(result, ", "))
}

func readFile() map[string][]float64 {

	fileName := "./files/cities_temperatures.csv"
	file, err := os.Open(fileName)
	if err != nil {
		panic(err)
	}
	// stat, err := file.Stat()
	// if err != nil {
	// 	panic(err)
	// }

	citiesList := make(map[string][]float64)
	reader := bufio.NewScanner(file)

	for reader.Scan() {
		text := reader.Text()
		index := strings.Index(text, ",")

		cityName := text[:index]
		temp := text[index+2:]

		// change to float64
		tem, err := strconv.ParseFloat(temp, 64)
		if err != nil {
			continue
		}

		citiesList[cityName] = append(citiesList[cityName], tem)

	}
	return citiesList
}
