# terraform-multiple-versions
A bash script that installs and switches over to different versions of terraform on mac. It is currently not yet tested on Linux.

The script will print out a menu and instructions should be easy to follow

> Once you select the required terraform version you can check that it is the correct running version by running the terraform command:
```
$ terraform version
```
<br/>

## This script:
```
1. retrieves different versions of Terraform packages;
2. installs a required version;
3. removes an unwanted package;
4. activates to an installed version on mac
```
<br/>

## Gotchas:
> The script was intended to be simple single file script that can be run from anywhere. Therefore if you want to modify the script watch out for the cheat in the menu generation.  
<br/>

## Note:
> The terraform versions older that 0.8.0 do not seem to working on Mac

