# Freelancer install scripts for linix distros
This script will detect what your distro is based on from the list below and download the correct files needed automaticlly
   - Arch
   - Fedora
   - Ubuntu
   - Debian

<HR>

# Getting the needed files
## 1. Save game files to your *~/Downloads* directory

[<img width="371" height="79" alt="FL" src="https://github.com/user-attachments/assets/1c19c857-028a-4ef4-96fa-6904695d436f" />](https://archive.org/download/Freelancer_201807/Freelancer.iso) <br>
[<img width="371" height="75" alt="DSCFL" src="https://github.com/user-attachments/assets/c0bc123b-c555-458b-b94b-013aa819e3f0" />](https://discoverygc.com/files/discovery_5.3.2.exe) <br>

## 2. Save scripts to your *~/* directory

   - Create text a text file named ***freelance_install.sh***
     - Copy the code from [here](freelancer_install.sh) and paste into the file you just created.
<br></br>
   - Create text a text file named ***discovery_install.sh***
     - Copy the code from [here](discovery_install.sh) and paste into the file you just created.

## 3. Install Freelancer
 - Be logged in are your normal user. ***DO NOT RUN THESE SCRIPTS AS SU OR ROOT***
 - Run `bash freelancer_install.sh`
 - Let the script run and answer ***YES*** to all default questions and install anything that pops up to their default settings.
    - Once the game is installed, do not run it yet. You need to run the mod first.
    - There are some instances where the command prompt is missing after the script has completed. Just hit the Enter key and it will come back
    - Depending on your distro, you'll most likely see the Freelancer game icon in your menu or quick launch bar.

## 4. Install Discovery Freelancer Mod
 - Run `bash discovery_install.sh`
 - Let the script run and answer ***YES*** to all default questions and install anything that pops up to their default settings.

## 5. Launching Discovery Freelancer
 - To launch the game you will need to to go the game directory which is:
    - `~/Freelancer/drive_c/users/$USER/AppData/Local/Discovery Freelancer 5.3.2`
 - From there type
    - `wine DSLauncher.exe`
 - Once the games launches click the **Apply Patch** link on the right side menu to upgrade to the latest version available.
 - This will also generate an icon on the menu bar. You can simply right click and pin it to make it easier to launch the game next time.
    - I'd recommend launching the game from this pinned icon before creating characters. If not, characters created from the CLI launch of the game may not show in the game launched from the pinned icon.
