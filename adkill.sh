#!/bin/bash
#adkill
#version 2.3
#by penthium for Viperr
#inspired by this script http://vsido.org/index.php?topic=757.0
############################################################ 
############################################################


############################################################
# Method for animation while script is working:
# to call it, use : spinner & ; pidspin=$(jobs -p) ; disown
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}
# Method to kill the animation :
killspinner() {
kill $pidspin 
printf "\n"
}
## download checker :
downloadchecker() {
if [[ $? = 0 ]] ; then
	echo "Download completed"
	else
	echo "Download Error"
fi
}
############################################################
#
#set variable to default setting for diferrents categories :
ats=0
fkn=0
gmb=0
prn=0
scl=0
while [[ -n "$1" ]]
	do
	case $1 in 
	--ats)
		ats=1
	;;
	--fkn)
		fkn=1
	;;
	--gmb)
		gmb=1
	;;	
	--prn)
		prn=1
	;;
	--scl)
		scl=1
	;;
	--all)
		ats=1
		fkn=1
		gmb=1
		prn=1
		scl=1
	;;

	*)
		echo "syntax error"
		echo "run adkill.sh <option>"
		echo "--ats : activate blacklist of ad/tracking & malware sites listed in the StevenBlack hosts file."
		echo "--fkn : activate blacklist of fake news sites listed in the StevenBlack hosts file."
		echo "--gmb : activate blacklist of gambling sites listed in the StevenBlack hosts file."
		echo "--prn : activate blacklist of porn sites listed in the StevenBlack hosts file."
		echo "--scl : activate blacklist of social sites listed in the StevenBlack hosts file."
		echo "--all : activate blacklist of all sites listed in the StevenBlack hosts file."
		exit 1
	;;
	esac
	shift
done

###########################################################


mkdir -p ~/.adkill
# If this is our first run, saves a copy of the system's original hosts file and sets it to read-only for safety
if [ ! -f ~/.adkill/hosts-system ]
then
 echo "Saving copy of system's original hosts file..."
 cp /etc/hosts ~/.adkill/hosts-system
 chmod 444 ~/.adkill/hosts-system
fi

# Perform work in temporary files
temphosts1=$(mktemp)
temphosts2=$(mktemp)
temphosts3=$(mktemp)
##########################################################
#
# Obtain various hosts files and merge into one
echo "Downloading ad-blocking hosts files..."
echo "Downloading from : winhelp2002.mvps.org :"
wget -nv -O - https://winhelp2002.mvps.org/hosts.txt >> "$temphosts1"
downloadchecker
echo "Downloading from githubusercontent.com :"
if [[ "$ats" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : ad/tracking + malwares"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts >> "$temphosts1"
	downloadchecker
fi
if [[ "$fkn" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : fake news sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts >> "$temphosts1"
	downloadchecker
fi
if [[ "$gmb" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : gambling sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling/hosts >> "$temphosts1"
	downloadchecker
fi
if [[ "$prn" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : porn sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts >> "$temphosts1"
	downloadchecker
fi
if [[ "$scl" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : social sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social/hosts >> "$temphosts1"
	downloadchecker
fi
echo "Downloading from someonewhocares.org :"
wget -nv -O - https://someonewhocares.org/hosts/hosts >> "$temphosts1"
downloadchecker
echo "Downloading from pgl.yoyo.org :"
wget -nv -O - "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" >> "$temphosts1"
downloadchecker


#read -p "STOP HERE"
# Do some work on the file:
printf "Parsing, cleaning, de-duplicating, sorting..."
#sed -e 's/\r//' -e '/localhost/d' -e 's/127.0.0.1/0.0.0.0/' -e 's/#.*$//' -e 's/[ \s]*$//' -e '/^$/d' -e 's/\s/ /g' -e '/^[^0]/d' "$temphosts1" | sort -u > "$temphosts2"
#sed -e 's/\r//;/localhost/d;s/127.0.0.1/0.0.0.0/;s/#.*$//;s/[ \s]*$//;/^$/d;s/\s/ /g;/^[^0]/d' "$temphosts1" | sort -u > "$temphosts2"
spinner &
pidspin=$(jobs -p)
disown

sed  -e "
{:remove_DOS_carriage;\
s/\r//};\
{:delete_localhost_lines;\
/localhost/d};\
{:delete_commented_line;\
s/#.*$//};\
{:delete_space_at_the_end_of_line;\
s/[ \s\t]*$//};\
{:delete_empty-line;\
/^$/d};\
{:replace_muti_space_by_only_one;\
s/[[:blank:]]\+/ /g};\
{:replace_127.0.0.1_by_0.0.0.;\
s/127\.0\.0\.1/0.0.0.0/};\
s/[ \s\t]$//;\
{:delete_line_who_not_start_by_zero;\
/^[^0]/d}" "$temphosts1" | sort -u > "$temphosts2"
killspinner 

## work : 
printf Merging with original system hosts...
spinner &
pidspin=$(jobs -p)
disown
# setting up progress status :
####

## work : 
head=$(mktemp)
unban=$(mktemp)

## extract head
#generation de l'entete :
sed -n '0,/# Ad blocking hosts generated/p' /etc/hosts | sed '$d' > $head
#generation du fichier des hosts commentés:
sed -n '/#\(0\.\)\{3\}0/p' /etc/hosts > $unban
#working :

while read line
 do
        sed  -i "/${line#\#}/d" $temphosts2
#################################

done < <(cat $unban)
killspinner



echo -e "# Ad blocking hosts generated: $(date +%d-%m-%Y)" | cat $head $unban - "$temphosts2" > ~/.adkill/hosts-block
# Clean up temp files and remind user to copy new file
echo "Cleaning up..."
rm "$temphosts1" "$temphosts2" "$head" "$unban"
echo "Done."

#test if it's root user who launch the script :

if [[ root = "$USER" ]] ; then
	cp -f ~/.adkill/hosts-block /etc/hosts 
	else
echo
echo "Copy ad-blocking hosts file with this command:"
echo "cd ; su -c 'cp .adkill/hosts-block /etc/hosts'"
echo
echo "You can always restore your original hosts file with this command:"
echo "cd ; su -c 'cp .adkill/hosts-system /etc/hosts'"
echo "so don't delete that file! (It's saved read-only for your protection.)"
fi
