#!/bin/bash
#adkill
#version 2.4
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
abu=0
cry=0
dru=0
fbk=0
fkn=0
frd=0
gmb=0
prn=0
scl=0
while [[ -n "$1" ]]
	do
	case $1 in 
	--ats)
		ats=1
	;;
	--abu)
		abu=1
	;;
	--cry)
		cry=1
	;;
	--dru)
		dru=1
	;;
	--fbk)
		fbk=1
	;;
	--fkn)
		fkn=1
	;;
	--frd)
		frd=1
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
		abu=1
		cry=1
		dru=1
		fkn=1
		frd=1
		gmb=1
		prn=1
		scl=1
	;;

	*)
		echo "syntax error"
		echo "run adkill.sh <option>"
		echo "--ats : activate blacklist of ad/tracking & malware sites listed in the StevenBlack & BlocklistProject hosts file."
		echo "--abu : activate blacklist of sites created to deceive listed in the BlocklistProject hosts file."
		echo "--cry : activate blacklist of crypto sites listed in BlocklistProject hosts file."
		echo "--dru : activate blacklist of drug sites listed in BlocklistProject hosts file (Illegal sites that deal with drugs)."
		echo "--fbk : activate blacklist of facebook sites (Blocking Facebook and Facebook relate/owned services) listed in the BlocklistProject hosts file."
		echo "--fkn : activate blacklist of fake news sites listed in the StevenBlack hosts file."
		echo "--frd : activate blacklist of fraud sites listed in the BlocklistProject hosts file."
		echo "--gmb : activate blacklist of gambling sites listed in the StevenBlack & BlocklistProject hosts file."
		echo "--prn : activate blacklist of porn sites listed in the StevenBlack hosts file."
		echo "--scl : activate blacklist of social sites listed in the StevenBlack hosts file."
		echo "--all : activate blacklist of all sites listed in the StevenBlack & BlockListProject hosts file."
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
echo -e "\e[1;32mDownloading ad-blocking hosts files...\e[0m"
echo "Downloading from : winhelp2002.mvps.org :"
wget -nv -O - https://winhelp2002.mvps.org/hosts.txt >> "$temphosts1"
downloadchecker
echo "Downloading from githubusercontent.com & blocklistproject.github.com :"
if [[ "$ats" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading StevenBlack via github : ad/tracking + malwares\e[0m"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts >> "$temphosts1"
	downloadchecker
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : ads\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/ads.txt >> "$temphosts1"
	downloadchecker
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : tracking\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/tracking.txt >> "$temphosts1"
	downloadchecker
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : malwares\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/malware.txt >> "$temphosts1"
	downloadchecker
	echo -e "\e[1;32mDownloading AdGuard via githubusercontent.com : CNAME records trackers\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/malware.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$abu" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : abused sites\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/abuse.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$cry" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : crypto sites\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/crypto.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$dru" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : drugs sites\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/drugs.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$fbk" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : facebook sites\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/facebook.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$fkn" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading StevenBlack via github : fake news sites\e[0m"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts >> "$temphosts1"
	downloadchecker
fi
if [[ "$frd" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : fraud sites\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/fraud.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$gmb" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading StevenBlack via github : gambling sites\e[0m"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling/hosts >> "$temphosts1"
	downloadchecker
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : gambling sites\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/gambling.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$prn" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading StevenBlack via github : porn sites\e[0m"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts >> "$temphosts1"
	downloadchecker
	echo -e "\e[1;32mDownloading Blocklist via blocklist.site : porn sites\e[0m"
	wget -nv -O - https://blocklistproject.github.io/Lists/porn.txt >> "$temphosts1"
	downloadchecker
fi
if [[ "$scl" = 1 ]] 
	then
	echo -e "\e[1;32mDownloading StevenBlack via github : social sites\e[0m"
	wget -nv -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social/hosts >> "$temphosts1"
	downloadchecker
fi
echo -e "\e[1;32mDownloading from someonewhocares.org :\e[0m"
wget -nv -O - https://someonewhocares.org/hosts/hosts >> "$temphosts1"
downloadchecker
echo -e "\e[1;32mDownloading from pgl.yoyo.org :\e[0m"
wget -nv -O - "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" >> "$temphosts1"
downloadchecker
echo -e "\e[1;32mDownloading phishing hosts file...\e[0m"
echo "Downloading from : blocklist.site"
wget -nv -O - https://blocklistproject.github.io/Lists/phishing.txt >> "$temphosts1"
downloadchecker
echo -e "\e[1;32mDownloading ransomware hosts file...\e[0m"
echo "Downlaoding from : blocklist.site"
wget -nv -O - https://blocklistproject.github.io/Lists/ransomware.txt >> "$temphosts1"
downloadchecker
echo -e "\e[1;32mDownloading Scam hosts files...\e[0m"
echo "Downloading from : blocklist.site"
wget -nv -O - https://blocklistproject.github.io/Lists/scam.txt >> "$temphosts1"
downloadchecker


#read -p "STOP HERE"
# Do some work on the file:
printf "\e[1;34mParsing, cleaning, de-duplicating, sorting...\e[0m"
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
echo -e "\e[1;32mDone.\e[0m"

#test if it's root user who launch the script :

if [[ root = "$USER" ]] ; then
	cp -f ~/.adkill/hosts-block /etc/hosts 
	else
echo
echo -e "\e[1;32mCopy ad-blocking hosts file with this command:\e[0m"
echo "cd ; su -c 'cp .adkill/hosts-block /etc/hosts'"
echo
echo -e "\e[1;32mYou can always restore your original hosts file with this command:\e[0m"
echo "cd ; su -c 'cp .adkill/hosts-system /etc/hosts'"
echo -e "\e[1;33mso don't delete that file! (It's saved read-only for your protection.)\e[0m"
fi
