extends Label

var num_reply = 0
signal reply_selected(a)

func _ready():

	pass


func _on_Label_mouse_enter():
	add_color_override("font_color", Color(1,0,1))

func _on_Label_mouse_exit():
	add_color_override("font_color", Color(1,1,1))


func _on_Label_input_event( ev ):
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == BUTTON_LEFT and ev.is_pressed():
		emit_signal("reply_selected",num_reply)