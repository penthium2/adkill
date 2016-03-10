#!/bin/bash
#adkill
#version 2.0
#by penthium for Viperr
#form original http://vsido.org/index.php?topic=757.0
############################################################ 
############################################################


############################################################
#Fonction for animation during works:
# to call the fonction use : spinner & ; pidspin=$(jobs -p) ; disown

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}
# Fonction to kill the animation :
killspinner() {
kill $pidspin 
printf "\n"
}
###########################################################


mkdir -p ~/.adkill
# If this is our first run, save a copy of the system's original hosts file and set to read-only for safety
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

# Obtain various hosts files and merge into one
echo "Downloading ad-blocking hosts files..."
echo "Downloading from : winhelp2002.mvps.org :"
wget -nv -O - http://winhelp2002.mvps.org/hosts.txt >> "$temphosts1"
if [[ $? = 0 ]] ; then
	echo "Download completed"
	else
	echo "Download Error"
fi
echo "Downloading from hosts-file.net :"
wget -nv -O - http://hosts-file.net/ad_servers.asp >> "$temphosts1"
if [[ $? = 0 ]] ; then
        echo "Download completed"
        else
        echo "Download Error"
fi
echo "Downloading from someonewhocares.org :"
wget -nv -O - http://someonewhocares.org/hosts/hosts >> "$temphosts1"
if [[ $? = 0 ]] ; then
        echo "Download completed"
        else
        echo "Download Error"
fi
echo "Downloading from pgl.yoyo.org :"
wget -nv -O - "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" >> "$temphosts1"
if [[ $? = 0 ]] ; then
        echo "Download completed"
        else
        echo "Download Error"
fi
echo "Downloading from downloads.sourceforge.net/project/adzhosts :"
wget -nv -O - "http://downloads.sourceforge.net/project/adzhosts/FORADAWAY.txt"  >> "$temphosts1"
if [[ $? = 0 ]] ; then
        echo "Download completed"
        else
        echo "Download Error"
fi
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
s/\s/ /g};\
{:replace_127.0.0.1_by_0.0.0.;\
s/127\.0\.0\.1/0.0.0.0/};\
s/[ \s\t]*$//;\
{:delete_line_who_not_start_by_zero;\
/^[^0]/d}" "$temphosts1" | sort -u > "$temphosts2"
killspinner 


# Combine system hosts with adblocks
echo Merging with original system hosts...
# setting up progress status :
count=0
total=$( cat $temphosts2 | wc -l)
##start=$(date +%s)
####

## work : 
while read line
 do
        if grep "$line" /etc/hosts > /dev/null
        then
                        echo "already blacklisted" > /dev/null
        else
                        echo "$line" >> $temphosts3
        fi
# visual progress :
##  cur=`date +%s`
  count=$(( $count + 1 ))
##  runtime=$(( $cur-$start ))
##  estremain=$(( ($runtime * $total / $count)-$runtime ))
##  printf "\r%d.%d%% complete ($count of $total) - est %d:%0.2d remaining\e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))
  printf "\r%d.%d%% complete ($count of $total) \e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10))
#################################

done < <(cat $temphosts2)
printf "\ndone\n"






echo -e "# Ad blocking hosts generated: $(date +%d-%m-%Y)" | cat /etc/hosts - "$temphosts3" > ~/.adkill/hosts-block
# Clean up temp files and remind user to copy new file
echo "Cleaning up..."
rm "$temphosts1" "$temphosts2" "$temphosts3"
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
