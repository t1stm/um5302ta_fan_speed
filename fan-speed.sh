#!/bin/sh
# Control the fans using EC-Probe
# Adresses found using ec-probe.exe in Windows 11.
# Used the MyASUS app.

Mode=""
EC_Address="0x61"
EC_Probe_Application_Name="ec-probe"

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--speed)
            Mode="$2"
            shift
            shift
            ;;
        -d|--default)
            Mode="default"
            shift
            shift
            ;;
        *)
            echo "Parameter \'$1\' not found." >&2;
            exit 1
            ;;
    esac
done

if [ "$Mode" = "" ]; then
	echo "No mode specified. Exiting." >&2;
	echo "
Available parameters are:
-s / --speed \"(performance or high), (normal, mid or default) and (whisper or low)\"
-d / --default" >&2;
	exit 1;
fi

EC_Probe_Location="$(which $EC_Probe_Application_Name)"

if [ $? -ne 0 ]; then 
	echo "NBFC EC-Probe isn't installed on the system. Please make sure it's installed, and present in \$PATH. (If you're using NBFC Linux please change the name of the executable in this script.)" >&2;
	exit 1;
fi

case $Mode in 
	performance|high)
		sudo "$EC_Probe_Location" write "$EC_Address" 0x02
		;;
	normal|mid|default)
		sudo "$EC_Probe_Location" write "$EC_Address" 0x00
		;;
	whisper|low)
		sudo "$EC_Probe_Location" write "$EC_Address" 0x01
		;;
	*)
		echo "Invalid fan speed parameter. Available options are \"(performance or high), (normal, mid or default) and (whisper or low)\"" >&2
		;;
esac
exit 0
