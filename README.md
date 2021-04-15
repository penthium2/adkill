# Adkill - Kill Ads without browser extension -
- Version :2.3
- Author : Penthium2
- Release date : 07-01-2016
- licence : GNU GPL V.3

Inspired by original [hakerdefo] script.

This script generates a powerful Hosts file for linux by merging 5 lists of advertisement references.
More than 100 000 hosts Banned.
# Usage :
Just run the script or add some options :
- --ats : activate blacklist of ad/tracking servers listed in StevenBlack hosts file.
- --fkn : activate blacklist of fake news sites listed in the StevenBlack hosts file.
- --gmb : activate blacklist of gambling sites listed in the StevenBlack hosts file.
- --prn : activate blacklist of porn sites listed in the StevenBlack hosts file.
- --scl : activate blacklist of social sites listed in the StevenBlack hosts file.
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
