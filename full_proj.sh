#! /bin/bash

#directory in which we will store the scraped dally data 
directory=/home/vboxuser/final_project/data/data_$(date +%d%m%y)
mkdir $directory

#Creat a file with a time stamp in its name
weather_report=raw_data_$(date +%d%m%y).txt

#Get current temp data of Casablanca city and store it in the file with the time stamp
city=Casablanca
curl wttr.in/$city >> $directory/$weather_report

#Extract only required data from raw data and store it in a temp file 
grep "°C" $directory/$weather_report >> $directory/temp_$(date +%d%m%y).txt

#Extract current temp and store it in a variable called obs_tmp
obs_tmp=$(cat $directory/temp_$(date +%d%m%y).txt |head -1 | tr -s " " | xargs | rev | cut -d " " -f2 | rev)
echo $obs_tmp

#Extract tomorrow's temp forecast for noon and store it in a variable called fc_temp
fc_temp=$(cat $directory/temp_$(date +%d%m%y).txt | head -3 | cut -d "C" -f2 | tr -s " " | xargs | rev | cut -d " " -f2 | rev)
echo $fc_temp

#Store current hour day month and year of the choosen city in a desctinct shell variables
hour=$(TZ='Morocco/Casablanca' date -u +%H)
day=$(TZ='Morocco/Casablanca' date -u +%d)
month=$(TZ='Morocco/Casablanca' date -u +%m)
year=$(TZ='Morocco/Casablanca' date -u +%Y)

#creat a txt file called rx_poc.log in which we store the extracted data separated by a tab
echo "$year $month $day $hour $obs_tmp $fc_temp" >> /home/vboxuser/final_project/rx_poc.log
