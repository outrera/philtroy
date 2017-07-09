extends StaticBody

signal look_at(a)

func _ready():
	pass

func _on_object_trigger_mouse_enter():
	emit_signal("look_at", "this is a cube")

func _on_object_trigger_mouse_exit():
	emit_signal("look_at", "")

func _on_object_trigger_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("look_at", "You can´t talk to objects.")

	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed():
		emit_signal("look_at", "You´re looking at the object.")

