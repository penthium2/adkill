# Adkill - Kill Ads without browser extension -
- Version :2.0
- Author : Penthium2
- Release date : 03-12-2016
- licence : GNU GPL V.3

Inspired by original [hakerdefo] script.

This script generates a powerful Hosts file for linux by merging 5 lists of advertisement references.

# Usage :
Just run the script.

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
