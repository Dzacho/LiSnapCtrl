# LiSnapCtrl
Simple bash script using gphoto2 package to remotely control shutter of your digital camera via USB and download photos.

You need the gphoto2 package (http://gphoto.org/) installed on your system and a camera that is supported (see if you can find it in the output of "gphoto2 --list-cameras").
If you have it, download the script LiSnapCtrl.sh, put it in your photos folder and make it runnable (e.g. by running "chmod a+x LiSnapCtrl.sh").
You will also need to change the key word on line 7 of the script in the part of checking connection with the camera.

The script lets you choose if you want to take photos on command or at intervals and the file extension you are using, in case of intervals it also asks for the length of interval and number of photos to take (endless mode included).
Other settings need to be (at least at the Nikon D80 communicating using PTP mode, which is the only camera I've tested) done on your camera.
The photos are named by date and time of shooting (using the date package) and stored in the same folder as the script.

The communications with the user is carried in Czech language (as I didn't care about sharing this script at the beginning), but after each "echo" there is a comment with English translation, so you can modify it for yourself.

Feel free to modify the script to fit your needs and shoot some great photos with it! (My motivation to create it was to shoot the aurora boreali at 11. 5. 2024, but I saw only clouds that evening...)
