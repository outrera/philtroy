# philtroy

Philemon Troy and the Student Body Pageant is a point´n´click adventure/dating game in the vein of Leisure suit Larry. The version on GitHub will be censored to comply with TOS, the code and functionality will be the same as the full version.

Disclaimer: THIS IS A VERY BAREBONES GAME PROTYPE RIGHT NOW. DON`T DOWNLOAD THIS EXPECTING A GAME ANYWHERE NEAR COMPLETION. It´s basically a cube gliding around on a board, talking to other cubes :) I will take two weeks off in september, and then I will work on graphics, until then, the code might still be interesting to you, if you want to make the same type of game.

Will not work on Godot 3.0! Tested and playing fine with 2.3 and 2.4 beta.

This Trello board is updated more frequently, if you want to track progress towards next release:
https://trello.com/b/MLCxDdmA/philemon-troy-and-the-student-body-pageant-roadmap

TODO:
- Replace testcube with actual meshes imported from Blender
- Implement schoolbag, calendar and map UI´s
- Implement day/night cycle functionality
- Implement event system
- implement save/load system
- implement start menu
- implement scene switching
- more cleanup and reorganizing, as always...

MAYBE:
- code my own dialogue editor. Writing json manually gets heavy after awhile, and I can´t find a dialogue editor that fits me

ISSUES:
- NPCs should remember previous dialogues
- Make sure that UI dialogues are really blocking
- how to store character properties? #pending merge of extended dialogue system


Updates:
=======

2017/07/31

Finished transferring NPCdialogue to global.charData
spent an hour chasing down a bug related to trying to set NPC identity data that wasn´t there...

next, make time progression actually do something, ie
- reload scene with data from location.json (which characters present, position, dialogue, branch)

next challenge (which I should have thought about)
- npcs should have different dialogues depending on time of day, meaning global.charData["dialogue"]
should be a 4 item array. Needs to be referenced correctly in dialogue.gd as well.. 

2017/07/30

prepared for day/night cycle functionality
- added "day", "month", "weekday", and "time" to gameData, which I moved to global.gd
- date label now dynamically updates with gametime progression
- click on calendar to progress time. Nothing happens, for now, except date label updating

created charData dictionary to hold json and branch info of all characters. Not hooked up to dialogue.gd yet..

started working on schoolbag and map UI. Just placeholder graphics and they won´t exit on esc yet..

also moved load_json() func to global.gd as it won´t be used by the dialogue script only

2017/07/29

Implemented 
- start and settings menu
- scene switching

Sanitized scene panel and world.gd script
- renamed nodes to better reflect their function
- grouped nodes under appropriate container 
- went through world.gd and renamed variables to follow camel case convention.

2017/07/28

- Moved all player script functions to player.gd from world.gd, further modularizing the game
- Cleaned up code, renamed "ui_elements" node to just "ui"
- created global.gd to handle higher level game functions, like quitting game/calling game menu/scene switching (for now)

2017/07/27

The last week has been spent (apart from a weekend on the French riviera:)extracting the dialogue system used in PhilTroy, expanding and modularizing it (for easier reutilization in other games) and putting it back into PhilTroy. The end result is called "Ape´s Dynamic Dialogue System" (or ADDS for short) This is an important step, which at first glance doesn´t seem all that significant, but the new features of this system are:

- NPCs remember what they´ve talked about before
- You can flip through replies and select reply with the keyboard
- You can alter game variables through dialogue choices
- Dialogue paging allows for longer dialogues
- custom talk animations per dialogue
- custom backgrounds per dialogue
- all dialogue functionality moved to its own script
- code was cleaned up for better readability

You can check the junkheap repository > extended dialogue system for full feature list.

ADDS will be made into a plugin, but that´s for later.

2017/07/16

Implemented simple turn and move towards functionality.
still some polishing needed. Player should move towards NPC before talking. ~~Turn speed should be relative to distance to target (with min and max speeds), and if close to target, player should turn without moving~~. Not hard to do, just need to take the time.

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

Move player around with mouseclick (be the testcube!)
UI hover effects
Dialogue system based on json
simple object and character collision

Manual:

LMB-click to initiate conversation
RMB-click to look at things, for more detalied descriptions
ESC to exit all UI dialogs
CTRL+Q to quit game
