# cdrtools-fix
> Fix genisoimage errors in Debian-based distributions with cdrtools

## Motivation

Have you ever attempted to create an ISO image on your Debian-based distribution? I have.  
Recently I tried to create a Slackware ISO and I can only say the experience wasn't the most pleasant. After getting a copy of the file tree onto my system I (actually it was the script I was using) tried to create an ISO out of it. Here's the result:  

![genisoimage error](https://github.com/RJ-Jesus/cdrtools-fix/raw/master/imgs/cdrtools-fix-0.png "genisoimage error")

Although it says 'Done!' in the end, notice the errors in the middle of the terminal window. I can confirm, no ISO was produced.

After some googling I came across the explanation: apparently **mkisofs** was replaced on Debian-based distributions by **genisoimage**. This would be OK as long as it didn't introduce this kind of problems.  
After more googling I came across the solution [here](http://ubuntuforums.org/showthread.php?t=851707) which states that an easy fix for this would be to replace **genisoimage** with the older **cdrtools** (which includes the also old **mkisofs**).  
After following the steps there I decided to write a simple shell script to help with the switch from **genisoimage** to the **cdrtools**. This is how this script was born.

## Making the switch

This is very easy since all is done by issuing

```sudo sh -c "wget https://github.com/RJ-Jesus/cdrtools-fix/raw/master/cdrtools_fix.sh -O - | sh"```

This needs **sudo** rights since it will write to `/usr/bin`, for example. You can obviously check the source code if you think it's going to do anything nasty.

This command assumes you have the package 'build-essential' installed and want the script to run with the default settings. Otherwise download it (`wget https://github.com/RJ-Jesus/cdrtools-fix/raw/master/cdrtools_fix.sh`) and check the help page (`cdrtools_fix.sh -h`).

## Conclusions

After replacing **genisoimage et al.** with **cdrtools** this is what I got trying to again create an ISO image of Slackware-current

![cdrtools working](https://github.com/RJ-Jesus/cdrtools-fix/raw/master/imgs/cdrtools-fix-1.png "cdrtools working")

And I can confirm that the ISO was indeed made.

There seems to be some bugs in the **genisoimage/wodim** suite and thus I think it's more advisable to keep using software that works, despite being older.

Ricardo Jesus
