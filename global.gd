extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_quit"):
		get_tree().quit()