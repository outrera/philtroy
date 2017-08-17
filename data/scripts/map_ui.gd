extends Area2D

onready var map01 = get_node("map01/Sprite")
onready var map02 = get_node("map02/Sprite")
onready var map03 = get_node("map03/Sprite")

onready var label = get_node("label")

signal exit_ui()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_map01_mouse_enter():
	map01.show()
	label.set_text("House 1")
	print(map01.get_pos())
	label.set_pos(get_node("map01").get_pos() + Vector2(-30, 45))
	
func _on_map01_mouse_exit():
	map01.hide()
	label.set_text("")

func _on_map01_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed:
		print("exit_ui_01")
		emit_signal("exit_ui")

func _on_map02_mouse_enter():
	map02.show()
	label.set_text("House 2")
	label.set_pos(get_node("map02").get_pos() + Vector2(-30, 45))

func _on_map02_mouse_exit():
	map02.hide()
	label.set_text("")

func _on_map02_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed:
		print("exit_ui_02")
		emit_signal("exit_ui")

func _on_map03_mouse_enter():
	map03.show()
	label.set_text("House 3")
	label.set_pos(get_node("map03").get_pos() + Vector2(-30, 45))

func _on_map03_mouse_exit():
	map03.hide()
	label.set_text("")

func _on_map03_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed:
		print("exit_ui_03")
		emit_signal("exit_ui")
