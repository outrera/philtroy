# philtroy
<<<<<<< HEAD
Philemon Troy and the Student Body Pageant
is a point´n´click adventure/dating game in the vein of Leisure suit Larry. The version on GitHub will be censored to comply with TOS, the code and functionality will be the same as the full version.
=======

Philemon Troy and the Student Body Pageant is a point´n´click adventure/dating game in the vein of Leisure suit Larry. The version on GitHub will be censored to comply with TOS, the code and functionality will be the same as the full version.
>>>>>>> 631e9f2ee1f99630db8c80aca5da0bf45fbc04c5

Disclaimer: THIS IS A VERY BAREBONES GAME FRAMEWORK RIGHT NOW. DON`T DOWNLOAD THIS EXPECTING A GAME ANYWHERE NEAR COMPLETION. It´s basically a cube gliding around on a board, talking to other cubes :) I will take two weeks off in september, and then I will work on graphics, until then, the code might still be interesting to you, if you want to make the same type of game.

Will not work on Godot 3.0! Tested and playing fine with 2.3 and 2.4 beta.

TODO:
<<<<<<< HEAD
- Replace testcube with actual meshes imported from Blender
- flip through relies and selecting with keyboard
- Implement schoolbag, calendar and map UI´s
- Implement day/night cycle functionality
- Implement event system
- implement dialogue paging for long dialogue texts 
- implement save/load system
- implement start menu
- implement scene switching
- more cleanup and reorganizing, as always...

MAYBE:
- code my own dialogue editor. Writing json manually gets heavy after awhile, and I can´t find a dialogue editor that fits me

ISSUES:
- NPCs should remember previous dialogues
- Make sure that UI dialogues are really blocking
- how to store character properties?



Updates:
=======

Replace testcube with actual meshes imported from Blender
flip through relies and selecting with keyboard
Implement schoolbag, calendar and map UI´s
Implement day/night cycle functionality
Implement event system
implement dialogue paging for long dialogue texts
implement save/load system
implement start menu
implement scene switching
more cleanup and reorganizing, as always...
MAYBE:

code my own dialogue editor. Writing json manually gets heavy after awhile, and I can´t find a dialogue editor that fits me
ISSUES:

NPCs should remember previous dialogues
Make sure that UI dialogues are really blocking
how to store character properties?
Updates:

2017/07/16

Implemented simple turn and move towards functionality.
still some polishing needed. Player should move towards NPC before talking. If mouseclick is too close to player, player won´t play fully. Turn speed should be relative to distance to target (with min and max speeds), and if close to target, player should turn without moving. Not hard to do, just need to take the time.
>>>>>>> 631e9f2ee1f99630db8c80aca5da0bf45fbc04c5

2017/07/09

version 0.0.2 alpha

<<<<<<< HEAD
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



=======
created a start_dialogue() function and moved over everything from load_json() that had nothing to do with actually loading a json (I might want to use it for other things tha dialogue...).
started implementing RMB look at-functionality
created a kill_dialogue() function since functionality is used more than once
finished converting Player, NPC´s and objects to instanced asset scenes
ESC to exit Phone UI and restore UI icons
General code cleanup and reorganizing
2017/07/08

First alpha, let´s call it v0.0.1 :) Very basic functionality, and placeholder graphics (or programmer art if you will;)

Features:

Move player around with mouseclick (be the testcube!)
UI hover effects
Dialogue system based on json
simple object and character collision
Manual:

LMB-click to initiate conversation
RMB-click to look at things, for more detalied descriptions
ESC to exit all UI dialogs
CTRL+Q to quit game
>>>>>>> 631e9f2ee1f99630db8c80aca5da0bf45fbc04c5
