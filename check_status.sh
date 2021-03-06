#!/bin/bash
statusHTTP="$(curl -s --head -m 2 http://$1 | grep -E -m1  "" |  cut -d' ' -f2)"  
statusHTTPS="$(curl -s --head -m 2 https://$1 | grep -E -m1  "" |  cut -d' ' -f2)" 
green=$(tput setaf 2)
blue=$(tput setaf 4)
red=$(tput setaf 1)
normal=$(tput sgr0)


function checkHTTP () {
if [[ "$statusHTTP" -ge 201 && "$statusHTTP" -lt 600 ]];
  then 
	# echo -e "http://\e[0;34m$1 \e[0m"is used ! \(status code="\e[0;34m $statusHTTP\e[0m"\) #'\U1F914'
	printf "http://${blue}$1${normal} is used ! (status code =${blue} $statusHTTP${normal})\n"
 
 elif [[ $statusHTTP -eq 200  ]]; then
	# echo -e "http://\e[0;32m$1 \e[0m"is working ! \(status code="\e[0;32m $statusHTTP\e[0m"\) '\U1F44D'
	printf "http://${green}$1${normal} is working ! (status code =${green} $statusHTTP${normal}) \U1F44D\n"

  else
	#echo -e "http://\e[0;31m$1 \e[0m"is not currently used.'\U274C' 
	printf "http://${red}$1${normal} is not currently used ! \U274C\n" 
fi






function checkHTTPS () {
if [[ "$statusHTTPS" -ge 201  && "$statusHTTPS" -lt 600 ]];
  then 
	# echo -e "https://\e[0;34m$1 \e[0m"is used ! \(status code="\e[0;34m $statusHTTPS\e[0m"\) #'\U1F914'
	 printf "https://${blue}$1${normal} is used ! (status code =${blue} $statusHTTPS${normal})\n"
	 printf '%70s\n' | tr ' ' -

elif [[ $statusHTTPS -eq 200  ]]; then
	# echo -e "https://\e[0;32m$1 \e[0m"is working ! \(status code="\e[0;32m $statusHTTPS\e[0m"\) '\U1F44D' 
	printf "https://${green}$1${normal} is working ! (status code =${green} $statusHTTPS${normal}) \U1F44D\n"
	printf '%70s\n' | tr ' ' -

  else
	# echo -e  "https://\e[0;31m$1 \e[0m"is not currently used. '\U274C'
	printf "https://${red}$1${normal} is not currently used ! \U274C\n" 
	printf '%70s\n' | tr ' ' -

fi
}
}
checkHTTP "$1" "$statusHTTP"
checkHTTPS "$1" "$statusHTTPS"
