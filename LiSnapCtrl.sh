#! /bin/bash

echo "Kontroluji připojení:" # "Check connection"
check=$(gphoto2 --auto-detect)
echo "$check"

if [[ $check == *"Nikon"* ]]; then # Key word depends on camera. Check your desired output of "gphoto2 --auto-detect".
    echo "Foťák nalezen."  # "Camera found"
else
    echo "Foťák nenalezen. Skript bude ukončen." # "Camera not found. The script will be terminated."
    exit 1
fi

while true; do
	echo -n "Chceš fotit na povel nebo v intervalech? (p/i) " # "Want to shoot on command or at intervals? (p/i)"
	read mode
	case $mode in
		p)
			echo "Budu fotit na povel. Ukončíš mne pomocí CTRL+C." # "I will shoot on command. Quit me with CTRL+C."
			break
			;;
		i)
			while true; do
				echo -n "Budu fotit v intervalech. Zadej interval v sekundách: " # "I will shoot at intervals. Enter the interval in seconds: " Please note that the camera spends non-zero time taking and processing a photo (its amount depends on your settings), therefore some small values are hard to reach; the script then shoots as fast as it can (doesn't wait any longer, if the shooting took too long).
				read interval
				# Verification that a number has been entered
				if [[ $interval =~ ^[0-9]+$ ]]; then
					echo "Interval je $interval s." # "Interval is $interval s."
					break;
				else
					echo "Neplatná hodnota, zadej nezáporné číslo." # "Invalid value, enter a non-negative integer."
				fi
			done
			while true; do
				echo -n "Kolik chceš fotek? Pro nekonečné focení zadej zápornou hodnotu (např. '-1'): " # "How many photos do you want? For endless shooting enter negative value (for example '-1'): "
				read photos
				# Verification that a number has been entered
				if [[ $photos =~ ^[0-9]+$ ]]; then
					echo "Vyfotím $photos fotek, případně mne ukončíš pomocí CTRL+C." # "I will take $photos photos or quit me with CTRL+C."
					break;
				elif [[ $photos =~ ^-?[0-9]+$ ]]; then
					echo "Budu fotit furt. Ukončíš mne pomocí CTRL+C." # "I will shoot endlessly. Quit me with CTRL+C."
					break;
				else
					echo "Neplatná hodnota, zadej celé číslo." # "Invalid value, enter a integer."
				fi
			done
			break
			;;
		*)
			echo "Zadej 'p' pokud chceš fotit na povel nebo 'i' pokud chceš fotit v intervalech. Jiné hodnoty jsou neplatné." # "Enter 'p' for shooting on command or 'i' for shooting at interval. Other values are invalid."
			;;
	esac
done

echo -n "Zadej koncovku souboru: " # "Enter the file extension: "
read fext
fext=$(echo "$fext" | sed 's/^\.\(.*\)/\1/') # Removes dot at beginning, if present.

SECONDS=0 # Set timer.

while true; do
	if [[ $mode == "p" ]]; then
		echo "Tak až řekneš \"Teď\"..." # "So when you say \"Now\"..."
		read key # Takes photo on "Enter" stroke.
	elif [[ $photos == 0 ]]; then
		exit 0
	elif [[ $photos > 0 ]]; then
		photos=$((photos - 1))
	fi
	fname="$(date +"%Y-%m-%d_%H-%M-%S").$fext"
	echo "Fotím $fname" # "Shoot $fname"
	gphoto2 --port usb: --capture-image-and-download --filename=$fname # gphoto2 shoots a photo, downloads it, names it $fname and deletes it from the camera. Although no photo remains in the camera, I think the camera needs some memory space to hold it before gphoto2 downloads it. It is of course possible to change this behavior (see output of "gphoto2 --help"). On PTP camera (as Nikon D80, the only one I've tested this with) it can only control the shutter, other settings need to be done on the camera.
	echo "Hotovo." # "Done."
	if [[ $mode == "i" ]]; then
		(( interval > $SECONDS )) && sleep $((interval-$SECONDS)) # Measures the time spent on the rest of the loop and waits the rest of the interval. If the code ran longer than the interval, shoots another photo immediatelly.
		SECONDS=0 # Reset timer.
	fi
done

