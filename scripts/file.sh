#!/bin/bash

# Function to generate a random temperature between -10 and 40
generate_random_temperature() {
    echo $((RANDOM % 51 - 10))
}

cd "../" && mkdir "files"

# Array of city names
cities=("New York" "Los Angeles" "Chicago" "Houston" "Phoenix" "Philadelphia" "San Antonio" "San Diego" "Dallas" "San Jose"
        "Austin" "Jacksonville" "San Francisco" "Columbus" "Fort Worth" "Indianapolis" "Charlotte" "Seattle" "Denver" "Washington"
        "Boston" "El Paso" "Nashville" "Detroit" "Oklahoma City" "Portland" "Las Vegas" "Memphis" "Louisville" "Baltimore"
        "Milwaukee" "Albuquerque" "Tucson" "Fresno" "Sacramento" "Kansas City" "Long Beach" "Mesa" "Atlanta" "Colorado Springs"
        "Miami" "Raleigh" "Omaha" "Minneapolis" "Tampa" "Saint Louis" "Pittsburgh" "Cincinnati" "Anchorage" "Honolulu" 
        "Mumbai" "Delhi" "Bangalore" "Chennai" "Kolkata" "Hyderabad" "Ahmedabad" "Pune" "Jaipur" "Lucknow"
        "Kanpur" "Nagpur" "Indore" "Thane" "Bhopal" "Visakhapatnam" "Pimpri-Chinchwad" "Patna" "Vadodara" "Ghaziabad"
        "Ludhiana" "Agra" "Nashik" "Ranchi" "Faridabad" "Meerut" "Rajkot" "Kalyan-Dombivali" "Vasai-Virar" "Varanasi"
        "Srinagar" "Aurangabad" "Dhanbad" "Amritsar" "Navi Mumbai" "Allahabad" "Ranchi" "Howrah" "Coimbatore" "Jabalpur"
        "Gwalior" "Vijayawada" "Jodhpur" "Madurai" "Raipur" "Kota" "Guwahati" "Chandigarh" "Solapur" "Hubballi-Dharwad"
        "Bareilly" "Moradabad" "Mysuru" "Tiruchirappalli" "Gurgaon" "Aligarh" "Jalandhar" "Bhubaneswar" "Salem" "Warangal"
        "Thiruvananthapuram" "Guntur" "Bhiwandi" "Saharanpur" "Gorakhpur" "Bikaner" "Amravati" "Noida" "Jamshedpur" "Bhilai"
        "Cuttack" "Firozabad" "Kochi" "Nellore" "Bhavnagar" "Dehradun" "Durgapur" "Asansol" "Nanded" "Ajmer" "Jamnagar"
        "Ujjain" "Sangli" "Loni" "Jhansi" "Ulhasnagar" "Jammu" "Saharsa" "Navi Mumbai" 
        "Moscow" "Saint Petersburg" "Novosibirsk" "Yekaterinburg" "Nizhny Novgorod" "Kazan" "Chelyabinsk" "Omsk" "Samara" "Rostov-on-Don"
        "Ufa" "Krasnoyarsk" "Voronezh" "Perm" "Volgograd" "Saratov" "Krasnodar" "Tolyatti" "Barnaul" "Irkutsk"
        "Ulyanovsk" "Vladivostok" "Yaroslavl" "Tyumen" "Ivanovo" "Khabarovsk" "Orenburg" "Novokuznetsk" "Kemerovo" "Ryazan"
        "Tomsk" "Astrakhan" "Kirov" "Penza" "Lipetsk" "Cheboksary" "Balashikha" "Kaliningrad" "Kursk" "Sevastopol"
        "Surgut" "Tula" "Magnitogorsk" "Kurgan" "Orsk" "Smolensk" "Vladikavkaz" "Chita" "Cherepovets" "Tambov"
        "Vologda" "Taganrog" "Kostroma" "Sterlitamak" "Novorossiysk" "Bratsk" "Dzerzhinsk" "Norilsk" "Engels" "Yakutsk"
        "Nalchik" "Shakhty" "Vladimir" "Mytishchi" "Kovrov" "Zlatoust" "Belgorod" "Angarsk" "Stavropol" "Rybinsk"
        "Prokopyevsk" "Yuzhno-Sakhalinsk" "Volzhsky" "Podolsk" "Tambov" "Yoshkar-Ola" "Korolev" "Orel" "Kurgan" "Syktyvkar"
        "Novocherkassk" "Kamensk-Uralsky" "Krasnogorsk" "Ulan-Ude" "Balakovo" "Armavir" "Serov" "Tagil" "Nakhodka" "Odintsovo"

)

# Number of rows to generate
num_rows=10000 

# Generate random data and append to the CSV file
for ((i = 1; i <= num_rows; i++)); do
    city=${cities[$((RANDOM % ${#cities[@]}))]}
    temperature=$(generate_random_temperature)
    echo "$city, $temperature" >> ./files/a1.csv
done

echo "CSV file generated: a1.csv"

# Source CSV file
source_file="./files/a1.csv"

# Destination directory
destination_dir="./files/"

# Create the destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Make 100 copies
for ((i = 1; i <= 100; i++)); do
    cp "$source_file" "$destination_dir/copy_$i.csv"
done

echo "100 copies of $source_file created in $destination_dir."


exclude_file="cities_temperatures.csv"
# Assuming you want to append the content of all CSV files in the current directory to cities_temperatures.csv
cat $(ls ./files/*.csv | grep -v "$exclude_file") >> ./files/cities_temperatures.csv

rm "$destination_dir/a1.csv"
for ((i = 1; i <= 100; i++)); do
    rm "$destination_dir/copy_$i.csv"
done
