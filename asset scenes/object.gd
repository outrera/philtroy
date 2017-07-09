extends StaticBody

signal look_at(a)
signal dialogue(b)

func _ready():
	pass


func _on_object_trigger_mouse_enter():
	emit_signal("look_at", "this is a cube")


func _on_object_trigger_mouse_exit():
	emit_signal("look_at", "")


func _on_object_trigger_input_event( camera, event, click_pos, click_normal, shape_idx ):
	pass # replace with function body
