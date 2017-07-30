extends StaticBody

signal look_at(a)
signal dialogue(a,b,c)

#will just carry character name, all other data will be moved to charData in global.gd
var identity = {"dialogue": "res://dialogue/ellie.json", "branch": "a", "name": "ellie"}

func _ready():
	pass

func _on_npc_trigger_mouse_enter():
	print("mousing")

func _on_npc_trigger_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			print("NPC")
			emit_signal("dialogue", identity.dialogue, identity.branch, identity.name, click_pos)

func _on_npc_trigger_mouse_exit():
	pass # replace with function body
