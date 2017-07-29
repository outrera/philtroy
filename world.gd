extends Node

var clickPos
var hoverNode = null

#flags/states
var isMoving = false
var isRotating = false
var noMoveOnClick = false
var blockingUI = false
var dialogueRunning = false
var phoneOpen = false

#get some nodes for easy access
onready var effectHoverUI = get_node("effects/tween")
onready var effectToggleUI = get_node("effects/tween")
onready var descriptionLabel = get_node("ui/descriptionLabel")

onready var viewsize = get_viewport().get_rect().size

func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	for object in get_node("objects").get_children():
		object.connect("look_at", self, "_look_at")
#	for object in get_node("npcs").get_children():
#		object.connect("dialogue", self, "_talk_to")

func _process(delta):
	#if dialogue is running and we press ui_exit, exit dialogue and delete dialogue nodes
	if Input.is_action_pressed("ui_exit"):
		if dialogueRunning == true:
			kill_dialogue()
		if phoneOpen == true:	
			noMoveOnClick = false #works same as blocking_ui, unify
			phoneOpen = false
			ui_hide_show(get_node("ui/ui_phone"), Vector2(0,1310), Tween.TRANS_QUAD, Tween.EASE_OUT)
			unhide_ui_icons()

func _fixed_process(delta):
	pass

func _input(event):
	if hoverNode and hoverNode.get_name() == "phone":	
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed():
			noMoveOnClick = true
			phoneOpen = true
			hide_ui_icons()
			ui_hide_show(get_node("ui/ui_phone"), Vector2(0,-1310), Tween.TRANS_QUAD, Tween.EASE_OUT)

#the below functions handle hover animations for UI icons. This could probably be handled more efficiently in one generic function, not sure how
func _on_phone_mouse_enter():
	ui_hover("phone", get_node("ui/phone/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/phone")

func _on_phone_mouse_exit():
	ui_hover("", get_node("ui/phone/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null

func _on_schoolbag_mouse_enter():
	ui_hover("school bag", get_node("ui/schoolbag/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/schoolbag")

func _on_schoolbag_mouse_exit():
	ui_hover("", get_node("ui/schoolbag/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null

func _on_map_mouse_enter():
	ui_hover("map", get_node("ui/map/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/map")

func _on_map_mouse_exit():
	ui_hover("", get_node("ui/map/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null

func _on_calendar_mouse_enter():
	ui_hover("calendar", get_node("ui/calendar/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/calendar")
		
func _on_calendar_mouse_exit():
	ui_hover("calendar", get_node("ui/calendar/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null

#play effects when hovering over UI icons
func ui_hover(name, gui_node, scale, move):
	descriptionLabel.set_text(name)
	noMoveOnClick = move
	effectHoverUI.interpolate_property (gui_node, "transform/scale", gui_node.get_scale(), scale, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	effectHoverUI.start()

#hide or show UI icons when calling blocking UI elements, like phone, map or schoolbag
func ui_hide_show(gui_node, move_delta, method1, method2):
	effectToggleUI.interpolate_property (gui_node, "transform/pos", gui_node.get_pos(), gui_node.get_pos() + move_delta, 1, method1, method2)
	effectToggleUI.start()

#combine two below functions into toggle_ui_icons(delta)
func hide_ui_icons():
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0,200), Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func unhide_ui_icons():
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0,-200), Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		
func _look_at(text):
	descriptionLabel.set_text(text)
	
#func _talk_to(dialogue, branch, name, click):
#	target_pos = click
#	isMoving = false
#	isRotating = true
