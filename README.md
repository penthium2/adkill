# Adkill - Kill Ads without browser extension -
- Version :2.0
- Author : Penthium2
- Release date : 03-12-2016
- licence : GNU GPL V.3

Inspired by original [hakerdefo] script.

This script generates a powerful Hosts file for linux by merging 5 lists of advertisement references.

# Usage :
Just run the script or add some options :
- --ats : activate blacklist of ad/tracking servers listed in the hpHosts database.
- --emd : activate blacklist of malware sites listed in the hpHosts database.
- --exp : activate blacklist of exploit sites listed in the hpHosts database.
- --fsa : activate blacklist of fraud sites listed in the hpHosts database.
- --grm : activate blacklist of sites involved in spam (that do not otherwise meet any other classification criteria) listed in the hpHosts database.
- --hfs : activate blacklist of sites spamming the hpHosts forums (and not meeting any other classification criteria) listed in the hpHosts database.
- --hjk : activate blacklist of hijack sites listed in the hpHosts database.
- --mmt : activate blacklist of sites involved in misleading marketing (e.g. fake Flash update adverts) listed in the hpHosts database.
- --pha : activate blacklist of illegal pharmacy sites listed in the hpHosts database.
- --psh : activate blacklist of phishing sites listed in the hpHosts database.
- --wrz : activate blacklist of warez/piracy sites listed in the hpHosts database.
- --all : activate blacklist of all sites listed in the hpHosts database.


Adkill creates ~/.adkill directory then
- backs up original /etc/hosts file named : **hosts-system**
- creates a file with all Adblock references : **hosts-block**

Each time you run **Adkill**, its analyses your hosts file and just add new ad sources. 
**So you can easily unblacklist an advertisement reference.**

- If you run **Adkill** with root, the merging of original hosts file and new advertisement references is automatic.
- If you run **Adkill** with normal user, **Adkill** prompts you how to merge manualy the advertisement references in your hosts file.

# Automation :
Copy **Adkill** in your /etc/cron.weekly directory.


[hakerdefo]: <http://vsido.org/index.php?topic=757.0>
