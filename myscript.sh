#!/bin/bash
#
# menu: A simple menu template
#
while true
do
	clear
	echo -n "
		Ben Cruz's CIS 90 Final Project
	1) Criterion Movie Match
	2) Speed Reader
	3) We Found Love
	4) Poetry Banners
	5) Local Weather
	6) Exit

	Enter Your Choice: "
	read RESPONSE
	case $RESPONSE in
	  1)  	# Commands for Criterion Collection difference engine
		echo -n "What is your name? "
		read NAME
		echo -n "What is your favorite movie? "
		read MOVIE
		echo "    Hi $NAME, would you like to check if $MOVIE is included in Criterion Collection? (y/n) "
		read SEARCH
		if [ "$SEARCH" = "y" ] || [ "$SEARCH" = "yes" ]; then
		if grep -iFxq "$MOVIE" /home/cis90/cruben/bin/criterion_list
		then
		    # Statement if film is found in local database
			echo "Yep, $MOVIE is included in the Criterion Collection."
		else
		    # Statement if not found
			echo "Nope, $MOVIE is not in the Criterion Collection."
		fi
		fi
		;;
	  2)  	# Commands for Speed Reader
		echo "This script will train to speed read by flashing one word at a time"
		echo "Please type either fast or faster to choose your reading speed"
		read speed
		if [ "$speed" = "faster" ]; then
		    sleepWait=.5
		else
		    sleepWait=1
		fi
		# outputs the sentence as a banner
		banner "Hi"; sleep $sleepWait; clear; banner "My"; sleep $sleepWait; clear; banner "name"; sleep $sleepWait; clear; banner "is"; sleep $sleepWait; clear; banner "$LOGNAME";
		;;
	  3)  	# Commands for We Found Love
		# Sets variable to user's first name
		set $(finger $LOGNAME | head -n1)
		firstName=$4
		echo "This script uses the grep command to find lines in your home directory with the word l-o-v-e"
		echo -n "Hey $4! Would you like to search for love ? "
		read confirm
		# if statement checks for Y,y,YES, or yes
		if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ] || [ "$confirm" = "YES" ] || [ "$confirm" = "yes" ]; then
		    echo "Here are your files that contain love: "
		    sleep 7
		    grep -hiR love ~/ 2> /dev/null
		else
		    echo "Perhaps you have already found love. Goodbye."
		fi
		;;
	  4)  	# Commands for Poetry Banners
		echo "        Welcome to POETRY BANNERS "
		# Sets the user's poems directory to a variable
		if [ -d $HOME/poems/ ]; then
		   poemsDir="$HOME/poems/"
		fi
		if [ -d $HOME/Poems ]; then
		    poemsDir="$HOME/Poems/"
		fi
		# Assigns the poems directory's authors as set command variavles
		#echo $poemsDir
		set $(ls -F $poemsDir | grep / )
		echo "Please select an author ( ${@%/} ): "
		read author
		# Selects a random file in the chosen author's poem directory
		randomFile=$(ls $poemsDir/$author | sort --random-sort | head -n1)
		# Passes a line from the randomly selected  poem to the banner command
		echo "The randomly selected poem is $randomFile "
		sleep 3
		head -n1 $poemsDir/$author/$randomFile | xargs banner
;;
	  5)  	# Commands for Cabrillo Weather
		echo "Hello $LOGNAME - Press enter to see the current weather for Cabrillo College (or enter a GPS coordinate)"
		read gps
		if [[ -z "$gps" ]]; then
		# Grab the forecast from a public databasep
			curl -# "http://forecast.weather.gov/MapClick.php?lat=36.97420&lon=-122.03&unit=0&lg=english&FcstType=text&TextType=1" | grep ":" | sed 's/<[^>]\+>/ /g' | head -n2 | tail -n1
		else
			lat=$(echo $gps | cut -d "," -f1)
			lon=$(echo $gps | cut -d "," -f2)
			echo "Your GPS Location is ($lat,$lon)"
			url="http://forecast.weather.gov/MapClick.php?lat=""$lat""&lon=""$lon""&unit=0&lg=english&FcstType=text&TextType=1"
			curl -# $url | grep ":" | sed 's/<[^>]\+>/ /g' | head -n2 | tail -n1
		fi
		echo "Would you like to get an email containg today's weather at Cabrillo? "
		read confirm
		# If user accepts, an email with current Cabrillo weather information gets emailed to the user's email acount
		if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ] || [ "$confirm" = "YES" ] || [ "$confirm" = "yes" ]; then
                    curl -# "http://forecast.weather.gov/MapClick.php?lat=36.97420&lon=-122.03&unit=0&lg=english&FcstType=text&TextType=1" | grep "This" | sed 's/<[^>]\+>/ /g' | mail -s "Current weather at Cabrillo" $LOGNAME
		echo "Email sent to your Opus account!"
                else
                    echo "Of course, the best way to check the weather is by peering outside your window..."
                fi
		;;
	  6)	exit 0
		;;
	  *)    echo "Please enter a number between 1 and 7"
		;;
	esac
	echo -n "Hit the Enter key to return to menu "
	read dummy
done
