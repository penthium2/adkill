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
emd=0
exp=0
fkn=0
fsa=0
gmb=0
grm=0
hfs=0
hjk=0
mmt=0
pha=0
prn=0
psh=0
scl=0
wrz=0
while [[ -n "$1" ]]
	do
	case $1 in 
	--ats)
		ats=1
	;;
	--emd)
		emd=1
	;;
	--exp)
		exp=1
	;;
	--fkn)
		fkn=1
	;;
	--fsa)
		fsa=1
	;;
	--gmb)
		gmb=1
	;;	
	--grm)
		grm=1
	;;	
	--hfs)
		hfs=1
	;;
	--hjk)
		hjk=1
	;;
	--mmt)
		mmt=1
	;;
	--pha)
		pha=1
	;;
	--prn)
		prn=1
	;;
	--psh)
		psh=1
	;;
	--scl)
		scl=1
	;;
	--wrz)
		wrz=1
	;;
	--all)
		ats=1
		emd=1
		exp=1
		fkn=1
		fsa=1
		gmb=1
		grm=1
		hfs=1
		hjk=1
		mmt=1
		pha=1
		prn=1
		psh=1
		scl=1
		wrz=1
	;;

	*)
		echo "syntax error"
		echo "run adkill.sh <option>"
		echo "--ats : activate blacklist of ad/tracking & malware sites listed in the StevenBlack hosts file."
#		echo "--emd : activate blacklist of malware sites listed in the hpHosts database."
#		echo "--exp : activate blacklist of exploit sites listed in the hpHosts database."
		echo "--fkn : activate blacklist of fake news sites listed in the StevenBlack hosts file."
#		echo "--fsa : activate blacklist of fraud sites listed in the hpHosts database."
		echo "--gmb : activate blacklist of gambling sites listed in the StevenBlack hosts file."
#		echo "--grm : activate blacklist of sites involved in spam (that do not otherwise meet any other classification criteria) listed in the hpHosts database."
#		echo "--hfs : activate blacklist of sites spamming the hpHosts forums (and not meeting any other classification criteria) listed in the hpHosts database."
#		echo "--hjk : activate blacklist of hijack sites listed in the hpHosts database."
#		echo "--mmt : activate blacklist of sites involved in misleading marketing (e.g. fake Flash update adverts) listed in the hpHosts database."
#		echo "--pha : activate blacklist of illegal pharmacy sites listed in the hpHosts database."
		echo "--prn : activate blacklist of porn sites listed in the StevenBlack hosts file."
#		echo "--psh : activate blacklist of phishing sites listed in the hpHosts database."
		echo "--scl : activate blacklist of social sites listed in the StevenBlack hosts file."
#		echo "--wrz : activate blacklist of warez/piracy sites listed in the hpHosts database."
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
#if [[ "$emd" = 1 ]] 
#if [[ "$emd" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : malware sites"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
#if [[ "$exp" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : exploit sites"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
if [[ "$fkn" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : fake news sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts >> "$temphosts1"
	downloadchecker
fi
#if [[ "$fsa" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : fraud sites"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
if [[ "$gmb" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : gambling sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling/hosts >> "$temphosts1"
	downloadchecker
fi
#if [[ "$grm" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : sites involved in spam"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
#if [[ "$hfs" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : sites spamming the hpHosts forums"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
#if [[ "$hjk" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : hijack sites"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
#if [[ "$mmt" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : sites involved in misleading marketing"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
#if [[ "$pha" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : illegal pharmacy sites"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
if [[ "$prn" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : porn sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts >> "$temphosts1"
	downloadchecker
fi
#if [[ "$psh" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : phishing sites"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
if [[ "$scl" = 1 ]] 
	then
	echo "Downloading StevenBlack via github : social sites"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social/hosts >> "$temphosts1"
	downloadchecker
fi
#if [[ "$wrz" = 1 ]] 
#	then
#	echo "Downloading from hosts-file.net : warez/piracy"
#	wget -nv -O - https://raw.githubusercontent.com/evankrob/hosts-filenetrehost/master/ad_servers.txt >> "$temphosts1"
#	downloadchecker
#fi
echo "Downloading from someonewhocares.org :"
wget -nv -O - https://someonewhocares.org/hosts/hosts >> "$temphosts1"
downloadchecker
echo "Downloading from pgl.yoyo.org :"
wget -nv -O - "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" >> "$temphosts1"
downloadchecker
#echo "Downloading from downloads.sourceforge.net/project/adzhosts :"
#wget -nv -O - "http://downloads.sourceforge.net/project/adzhosts/FORADAWAY.txt"  >> "$temphosts1"
#downloadchecker


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
