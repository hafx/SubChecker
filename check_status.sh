#!/bin/bash
statusHTTP="$(curl -s --head -m 2 http://$1 | grep -E -m1  "" |  cut -d' ' -f2)"  
statusHTTPS="$(curl -s --head -m 2 https://$1 | grep -E -m1  "" |  cut -d' ' -f2)" 

function checkHTTP () {
if [[ "$statusHTTP" -ge 201 && "$statusHTTP" -lt 600 ]];
  then 
	 echo -e "http://\e[0;34m$1 \e[0m"is used ! \(status code="\e[0;34m $statusHTTP\e[0m"\) #'\U1F914'
elif [[ $statusHTTP -eq 200  ]]; then
	echo -e "http://\e[0;32m$1 \e[0m"is working ! \(status code="\e[0;32m $statusHTTP\e[0m"\) '\U1F44D'

  else
	 echo -e "http://\e[0;31m$1 \e[0m"is not currently used.'\U274C'
fi

function checkHTTPS () {
if [[ "$statusHTTPS" -ge 201  && "$statusHTTPS" -lt 600 ]];
  then 
	 echo -e "https://\e[0;34m$1 \e[0m"is used ! \(status code="\e[0;34m $statusHTTPS\e[0m"\) #'\U1F914'
	 printf '%70s\n' | tr ' ' -

elif [[ $statusHTTPS -eq 200  ]]; then
	echo -e "https://\e[0;32m$1 \e[0m"is working ! \(status code="\e[0;32m $statusHTTPS\e[0m"\) '\U1F44D' 
	printf '%70s\n' | tr ' ' -

  else
	echo -e  "https://\e[0;31m$1 \e[0m"is not currently used. '\U274C'
	printf '%70s\n' | tr ' ' -

fi
}
}
checkHTTP "$1" "$statusHTTP"
checkHTTPS "$1" "$statusHTTPS"
