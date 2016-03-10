# Adkill - Kill Advertissement without navigator extention -
- Version :2.0
- Author : Penthium2
- Release date : 03-12-2016
- licence : GNU GPL V.3

Inspirate form original [hakerdefo] script.

This script generate a powerfull Hosts file for linux by contatenation of 5 source list of advertissement website.

# Usage :
Just run the script.

Adkill create ~/.adkill directory 
- save of the original /etc/hosts file named : **hosts-system**
- create a file with all Adblock reference : **hosts-block**

Each time you run **Adkill**, adkill analyse your hosts file and just add new advertissement reference. 
**So you can easly unblacklist a advertissement reference.**

- If you run **Adkill** with root, the merging of original hosts file and new advertisement reference is automatic.
- If you run **Adkill** with normal user, **Adkill** pront you how to merge manualy the advertissement reference in your hosts file.

# Automatisation :
copy **Adkill** in your /etc/cron.weekly directory.


[hakerdefo]: <http://vsido.org/index.php?topic=757.0>
