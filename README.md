# Linux Install Scripts 
   - Freelancer (2003)
   - Discovery Freelancer 5.3.2 Mod
<HR>

## 1. Download game files to your *~/Downloads* directory
[<img width="371" height="79" alt="FL" src="https://github.com/user-attachments/assets/1c19c857-028a-4ef4-96fa-6904695d436f" />](https://archive.org/download/Freelancer_201807/Freelancer.iso) <br>
[<img width="371" height="75" alt="DSCFL" src="https://github.com/user-attachments/assets/c0bc123b-c555-458b-b94b-013aa819e3f0" />](https://discoverygc.com/files/discovery_5.3.2.exe) <br>

## 2. Download scripts to your *~/* directory
   - Copy/Download [Freelancer Install Script](freelancer_install.sh) 
   - Copy/Download [Discovery Freelancer Mod Install Script](discovery_install.sh) 

## 3. Install Freelancer
 - Be logged in are your normal user. ***DO NOT RUN THESE SCRIPTS AS SU OR ROOT***
 - Run `bash freelancer_install.sh`
 - Let the script run and answer ***YES*** to all default questions and install anything that pops up to their default settings.
 - Once the game is installed, do not run it yet. You need to run the mod first.
 - There are some instances where the command prompt is missing after the script has completed. Just hit the Enter key and it will come back
 - Depending on your distro, you'll most likly see the Freelancer game icon in your menu or quick launch bar.

## 4. Install Discovery Freelancer Mod
 - Run `bash discovery_install.sh`
 - Let the script run and answer ***YES*** to all default questions and install anything that pops up to their default settings.

## 5. Launching Discovery Freelancer
 - To launch the game you will need to to go the game directory which is
    - `$HOME/Freelancer/drive_c/users/$USER/AppData/Local/Discovery Freelancer 5.3.2`
 - From there type
    - `wine DSLauncher.exe`
 - Once the games launches click the **Apply Patch** link on the right side menu to upgrade to the latest version available.
 - This will also generate an icon on the menu bar. You can simply right click and pin it to make it easier to launch the game next time.
    - I'd recommend launching the game from this pinned icon before creating characters. If not, characters created from the CLI launch of the game may not show in the game launched from the pinned icon.
