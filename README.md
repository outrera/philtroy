# philtroy
Philemon Troy and the Student Body Pageant
is an adventure//dating game in the vein of Leisure suit Larry. The version on GitHub will be censored to comply with TOS, the code and functionality will be the same as the full version, though. Someone would probably give this game a Mature 17+ rating. 

Will not work on Godot 3.0! Tested and playing fine with 2.3 and 2.4 beta.

TODO next:
- Implement schoolbag and map UI´s
- Implement daycycle functionality
- NPCs should remember previous dialogues
- Implement event system (with calendar UI)
- more cleanup and reorganizing, as always...

Updates:

2017/07/09

version 0.0.2 alpha

- created a start_dialogue() function and moved over everything from load_json() that had nothing to do with actually loading a json (I might want to use it for other things tha dialogue...).
- started implementing RMB look at-functionality
- created a kill_dialogue() function since functionality is used more than once
- finished converting Player, NPC´s and objects to instanced asset scenes
- ESC to exit Phone UI and restore UI icons
- General code cleanup and reorganizing

2017/07/08

First alpha, let´s call it v0.0.1 :)
Very basic functionality, and placeholder graphics (or programmer art if you will;)

Features:
- Move player around with mouseclick (be the testcube!)
- UI hover effects
- Dialogue system based on json
- simple object and character collision 

Manual:
- LMB-click to initiate conversation
- RMB-click to look at things, for more detalied descriptions
- ESC to exit all UI dialogs
- CTRL+Q to quit game



