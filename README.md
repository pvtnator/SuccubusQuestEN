# Succubus Quest translation project.
Mostly edited MTL using a combination of many tools and some basic understanding of Japanese.
If you encounter issues, please read below so you understand what are relevant bugs to report.
In general, please report game logic bugs (from a fresh save).

### Original work by SQDT. The official game is required to apply this patch.

## Progress
I'm currently going through the game, translating everything I come across.
Many things are missing, but you could basically play up to where I am currently in English.

## Patching Instructions
Currently this translation is only available through the patching.
Release versions will come later.
This project uses RPGMaker Trans https://rpgmakertrans.bitbucket.io/index.html
In addition, some python scripts. Make sure to have up to date Python installed (3.5+ is fine I think)

1. Have unmodified Mar/20/2020 version of the game
2. With RPGMaker Trans, choose the .exe of the game, and have this repository in a folder next to the game, with "_patch" appended to the folder name
   (e.g. Succubus Quest is the game folder, Succubus Quest_patch contains this repository)
   This should generate a folder with "_translated" appended to its name, containing the translated game.
3. Run the "patch.bat", which will execute "patcher.py" with python.
   It will also attempt to run RPGMaker Trans command line version, so if you got that (in an adjacent folder) you can skip using the GUI for it.
   If your python goes by "python3", try editing the .bat. You can also run those scripts directly yourself.
4. Now the game should be decrypted and the individual files are in the data folder.
   In the unpatched game's root folder, rename the files starting with "P_" so you remove that prefix, then copy them to the data folder.
   These are patch files, but we need them in the data folder so they get translated.
   Now patch the game again.
5. After updates, apply the patches the same way. No need to delete the game or anything, normally at least.

Note that as things are, this won't modify your saves, and your saves contain some strings, which would lead to discrepency and then bugs.
In other words, it's best to start a new save after applying this mod, although it may work to certain extent, or you could manually modify your saves to match.
Note also that when you load a save, the current map is loaded from the save and changes won't be applied until you re-enter that map.
