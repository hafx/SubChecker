#!/bin/bash

option=$1
domain=$2


#calculate the number of days remaining before the registry expiration date
function dayRemaining () {
whois $domain | grep "Registry Expiry Date" | cut -d'T' -f1 | cut -d':' -f2 | cut -d ' ' -f2 > tmp/expiration
expiration=`cat tmp/expiration`



string=`uname -s`
if [[ $string == *"Linux"* ]]; then
#Linux
date +"%y-%m-%d" > tmp/today
today=`cat tmp/today`
printf "Registry expiry date \e[1;29m $domain\e[0m : $(( ($(date -d $expiration +%s) - $(date -d $today +%s)) / 86400 )) days left\n"

else
#OSX/BSD

#date +"%y-%m-%d" > tmp/today
#today=`cat tmp/today`
#printf "Registry expiry date \e[1;29m $domain\e[0m : $(( ($(date -d $expiration +%s) - $(date -d $today +%s)) / 86400 )) days left\n"
	
printf "If OSX works for you, then use it.\U1F4B0\n"
fi
}


# parsing crt.sh and enumerate subdomains + check status web server 
function parsingHTML () {
curl --silent "https://crt.sh/?q=$domain" | grep "<TD>" | grep -v white-space | cut -d ">" -f2 | cut -d "<" -f1 |sort -u | grep -v -e '*' -e '@' | grep $domain | xargs -I {} ./check_status.sh  {}
}


# Using api virustotal
function apiVirusTotal () {
apikey=`cat apikey.txt`
wget -q -O - https://www.virustotal.com/vtapi/v2/domain/report\?apikey\=$apikey\&domain\=$domain |grep -o "\b\w*\.$domain\b" > tmp/subdomainVirusTotal.txt
printf "$domain\n$(cat tmp/subdomainVirusTotal.txt)" | sort -u |  xargs -I {} ./check_status.sh  {}
}


# banner
function banner () {
echo "   _____       _      _____ _               _              "
echo "  / ____|     | |    / ____| |             | |             "
echo " | (___  _   _| |__ | |    | |__   ___  ___| | _____ _ __  "
echo "  \___ \| | | | '_ \| |    | '_ \ / _ \/ __| |/ / _ \ '__| "
echo "  ____) | |_| | |_) | |____| | | |  __/ (__|   <  __/ |    "
echo " |_____/ \__,_|_.__/ \_____|_| |_|\___|\___|_|\_\___|_|    "
echo "             __                    ___        "
echo "            |__) \ /    |__|  /\  |__  \_/    "
echo "            |__)  |     |  | /~~\ |    / \    "

printf "\n"
}


#check wildcard DNS 
function wildcardcheck () {

#generate random string
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 |  awk '{print $0"."}' > tmp/randomsub	
subgen=`host $(cat tmp/randomsub)$domain`
if [[ $subgen == *"has address"* ]]; then
	echo "checking for DNS wildcard : YES "
else 
	echo "checking for DNS wildcard : NO"

        fi
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

banner
if  [[ $option = "--EXT" ]]; then
	printf "\e[1;31mYou are going to check the domain with an external website. (https://crt.sh)  \e[0m\n\n" 


	 	
dayRemaining "$domain"
# draw a horizontal line 
#printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
printf '%80s\n' | tr ' ' -

wildcardcheck
printf '%80s\n' | tr ' ' -

parsingHTML $domain


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

elif [[ $option = "--API" ]]; then
	printf "\e[1;31mYou are going to check the domain with the VirusTotal API. \nPlease make sur you have copy your own api key in \"apikey.txt\" \e[0m\n\n"

dayRemaining "$domain"
# draw a horizontal line 
#printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
printf '%80s\n' | tr ' ' -

wildcardcheck
printf '%80s\n' | tr ' ' -

apiVirusTotal "$domain"


#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

else
	printf "Please choose an option (--EXT or --API)\n"  
	printf "example : ./SubChecker.sh --EXT github.com"
	printf "example : ./SubChecker.sh --API github.com"
fi








