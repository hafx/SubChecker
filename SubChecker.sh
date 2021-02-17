#!/bin/bash

option=$1
domain=$2


#calculate the number of days remaining before the registry expiration date
function dayRemaining () {
whois $domain | grep "Registry Expiry Date" | cut -d'T' -f1 | cut -d':' -f2 | cut -d ' ' -f2 > expiration
expiration=`cat expiration`
date +"%y-%m-%d" > today
today=`cat today`
echo -e Registry expiry date "\e[1;29m $domain\e[0m" : $(( ($(date -d $expiration +%s) - $(date -d $today +%s)) / 86400 )) days left 
}


# parsing crt.sh and enumerate subdomains + check status web server 
function parsingHTML () {
curl --silent "https://crt.sh/?q=$domain" | grep "<TD>" | grep -v white-space | cut -d ">" -f2 | cut -d "<" -f1 |sort -u | grep -v -e '*' -e '@' | grep $domain | xargs -I {} ./check_status.sh  {}
}


# Using api virustotal
function apiVirusTotal () {
apikey=`cat apikey.txt`
wget -q -O - https://www.virustotal.com/vtapi/v2/domain/report\?apikey\=$apikey\&domain\=$domain |grep -o "\b\w*\.$domain\b" > subdomainAPI.txt
echo -e "$domain\n$(cat subdomainAPI.txt)" | sort -u |  xargs -I {} ./check_status.sh  {}
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


if  [[ $option = "--EXT" ]]; then
	echo -e "\e[0;31mYou are going to check the domain with an external website. (https://crt.sh)  \e[0m" 

dayRemaining "$domain"
# draw a horizontal line 
#printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
printf '%80s\n' | tr ' ' -
parsingHTML $domain


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

elif [[ $option = "--API" ]]; then
echo -e "\e[0;34mYou are going to check the domain with the VirusTotal API. \nPlease make sur you have copy your own api key in \"apikey.txt\" \e[0m"

dayRemaining "$domain"
# draw a horizontal line 
#printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
printf '%80s\n' | tr ' ' -
apiVirusTotal "$domain"


#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

else
	echo "Please choose an option (--EXT or --API)"
fi








