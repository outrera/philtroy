extends StaticBody

signal look_at(a)
signal dialogue(a,b)

#will just carry character name, all other data will be moved to charData in global.gd
var identity = "ellie"

func _ready():
	pass
	
func _on_npc_trigger_mouse_enter():
	emit_signal("look_at", identity)

func _on_npc_trigger_mouse_exit():
	emit_signal("look_at", "")

func _on_npc_trigger_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("dialogue", identity, self.get_transform().origin)


