#!/bin/bash

#Program determines if input is going to be manual or from a file.

echo "Would you like to upload report from a file?"
read ANSWER

#I create a loop to keep the program running until a satisfactory answer is 
#provided by the user

LOOP=0
while [[ $LOOP -eq 0 ]] ; do
  case $ANSWER in

#Program reads input filename and saves it as a variable

  "Yes"|"yes"|"Y"|"y"|"YES" )
	items=()
	x="a"
	while [[ ${x} != "" ]] ; do
	read  -p "Input file name:  " x
	if [[ "$x" != "" ]]; then
		echo "$x added add next file or press enter to continue"
    	items+=( "$x" )
	else
		echo "Files added"
	fi
	done
	LOOP=1
	SELECTOR=ONE
	;;

#Program instructs user to put inputs and records them as variables

  "No"|"no"|"N"|"n"|"NO" )
	echo "Input Who, input @ to finish"
	read -e -d @ Who
	echo "Input What, input @ to finish"
	read -e -d @ WHAT
	echo "Input When, input @ to finish"
	read -e -d @ WHEN
	echo "Input Where, input @ to finish"
	read -e -d @ WHERE
	echo "Input Why, input @ to finish"
	read -e -d @ WHY
	LOOP=1
	SELECTOR=TWO
	;;
#Program returns an error message if the answer to the first question is
# not a yes or a no.

  * )
	echo "You must answer with a yes or a no, try again"
	read ANSWER
	;;
  esac
done

#Program executes and makes a variable from the date command for later use

DATE=`date +%d%b%g_%H%M%S`

#Program determines whether to compile information provided by the user into
#a .txt file or to transfer the contents of a seperate file into a .txt file

case "$SELECTOR" in

 "ONE" )

#Program creates a loop here which will check to see if the file exists and  
#assign the filepath to a variable.

	LOOP2=0 
	touch 5Ws_$DATE.txt
	for FILE_NAME in "${items[@]}"
	do
	echo "iterating through files"
	while [[ $LOOP2 -eq 0 ]] ; do 
		if [[ -n $( find  ~/ -iname "$FILE_NAME" ) ]] ; then
			FILEPATH=`find ~/ -type f -iname "$FILE_NAME"`
			LOOP2=1
			echo $FILEPATH
			cat $FILEPATH >> ./5Ws_$DATE.txt
		else
			echo "$FILE_NAME Doesn't Exist or is not readable, try again"
			read FILE_NAME
		fi
	done
	
#Program now takes the file specified transfers the contents into a newly 
#created file and then archives, compresses, and encrypts it while also adding
#a time stamp. Finally, the program deletes the unencrypted file.
	

	done
	tar -r --file=./5Ws_$DATE.tar.gz ./5Ws_$DATE.txt 
	gpg -r USERGUY -e ./5Ws_$DATE.tar.gz
	shred -u ./5Ws_$DATE.tar.gz
	shred -u ./5Ws_$DATE.txt
  ;;

#Program compiles manual answers of the user and puts them in a text file.
#Program then archives, compresses, and encrypts the new file while also adding
#a time stamp. Finally, the program deletes the unencrypted file.

 "TWO" )
	touch ./5Ws_$DATE.txt
	echo "WHO:" >> ./5Ws_$DATE.txt
	echo $WHO >> ./5Ws_$DATE.txt
	echo " =========================================================== " >> ./5Ws_$DATE.txt
	echo "WHAT:" >> ./5Ws_$DATE.txt
	echo $WHAT >> ./5Ws_$DATE.txt
	echo " =========================================================== " >> ./5Ws_$DATE.txt
	echo "WHEN:" >> ./5Ws_$DATE.txt
	echo $WHEN >> ./5Ws_$DATE.txt
 	echo " =========================================================== "  >> ./5Ws_$DATE.txt
	echo "WHERE:" >> ./5Ws_$DATE.txt
	echo $WHERE >> ./5Ws_$DATE.txt
	echo " =========================================================== "  >> ./5Ws_$DATE.txt
	echo "WHY:" >> ./5Ws_$DATE.txt
	echo $WHY >> ./5Ws_$DATE.txt
	echo " =========================================================== " >> ./5Ws_$DATE.txt
	tar -czf ./5Ws_$DATE.tar.gz ./5Ws_$DATE.txt 
	gpg -r USERGUY -e ./5Ws_$DATE.tar.gz
	shred -u ./5Ws_$DATE.tar.gz
	shred -u ./5Ws_$DATE.txt

  ;;

  * )
	echo "Critical Failure, check program code"
	exit 1
  ;;
esac
