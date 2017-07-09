extends StaticBody

signal look_at(a)
signal dialogue(a,b)

func _ready():
	pass

func _on_npc_trigger_mouse_enter():
	emit_signal("look_at", "this is an NPC")

func _on_npc_trigger_mouse_exit():
	emit_signal("look_at", "")

func _on_npc_trigger_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("dialogue", "res://dialogue/ellie_start.json","a")

	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed():
		emit_signal("look_at", "This NPC is sexy as f-ck!")
