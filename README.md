# Succubus Quest translation project.
Mostly edited MTL using a combination of many tools and some basic understanding of Japanese.
If you encounter issues, please read below so you understand what are relevant bugs to report.
In general, please report game logic bugs (from a fresh save).

### Original work by SQDT. The official game is required to apply this patch.

## Progress
I have done one playthrough and translated mostly everything on the way. The game should be fully playable start to finish in English, but some non-essential texts are untranslated and there are probably some things I just missed. I also haven't playtested from the start with all the updates to ensure there are no issues, but presumably it should be fine. 

## Patching Instructions
Currently this translation is only available through the patching.
Release versions will come later.
This project uses RPGMaker Trans https://rpgmakertrans.bitbucket.io/index.html.
For easier patching, get the command line (CLI) version.
In addition, some python scripts. Make sure to have up to date Python installed (3.5+ is fine I think).

1. Have unmodified Mar/20/2020 version of the game
2. Place RPGMaker Trans into a folder called "rpgmt_cli_v4.5" such that this and the game folder are in the same directory.
4. Run the "patch.bat", which will execute "patcher.py" with python.
   If your python goes by "python3", try editing the .bat. You can also run those scripts directly yourself.
5. Now the game should be decrypted and the individual files are in the data folder.
   In the unpatched game's root folder, rename the files starting with "P_" so you remove that prefix, then copy them to the data folder.
   These are patch files, but we need them in the data folder so they get translated.
   Now patch the game again.
6. After updates, apply the patches the same way. No need to delete the game or anything, normally at least.

Note that as things are, this won't modify your saves, and your saves contain some strings, which would lead to discrepency and then bugs.
In other words, it's best to start a new save after applying this mod, although it may work to certain extent, or you could manually modify your saves to match.
Note also that when you load a save, the current map is loaded from the save and changes won't be applied until you re-enter that map.
