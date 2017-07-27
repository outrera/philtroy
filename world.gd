extends Node

var value = 0
var game_data = {}
var curpos
var startpos
var direction
var player_speed = 7
var click_pos
var distance_to_target
var hover_node = null

#flags/states
var is_moving = false
var no_move_on_click = false
var blocking_ui = false
var dialogue_running = false
var phone_opened = false

#get some nodes for easy access
onready var effect_ui_hover = get_node("effects/ui_hover")
onready var effect_ui_hide_show = get_node("effects/ui_hide_show")
onready var label_hotspot = get_node("ui_elements/Label_hotspot")

onready var viewsize = get_viewport().get_rect().size

onready var player_viewport_pos = get_node("camera").unproject_position(get_node("player").get_global_transform().origin)
onready var target_viewport_pos = Vector3(0,0,0)

#onready var player_label = get_node("player/player_label")
#onready var target_label = get_node("target/target_label")
	
onready var player = get_node("player")
onready var target = Vector3(0,0,0)
onready var helper = get_node("player/rotation_helper/Position3D")
	
onready var target_pos = Vector3(0,0,0)
onready var player_pos = player.get_global_transform().origin
onready var helper_pos = helper.get_global_transform().origin	

var playerFacing

var movement = Vector3()

func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	for object in get_node("objects").get_children():
		object.connect("look_at", self, "_look_at")

func _process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_quit"):
		get_tree().quit()
	#if dialogue is running and we press ui_exit, exit dialogue and delete dialogue nodes
	if Input.is_action_pressed("ui_exit"):
		if dialogue_running == true:
			kill_dialogue()
		if phone_opened == true:	
			no_move_on_click = false #works same as blocking_ui, unify
			phone_opened = false
			ui_hide_show(get_node("ui_elements/ui_phone"), Vector2(0,1310), Tween.TRANS_QUAD, Tween.EASE_OUT)
			unhide_ui_icons()
	
func _fixed_process(delta):
	#move and rotate player towards set target
	if is_moving:
		if !blocking_ui:
			turn_towards()
			if player_pos.distance_to(target_pos) > 3:
				player.move(playerFacing*get_fixed_process_delta_time()*3)

func turn_towards():
	var t = player.get_transform()
	var lookDir = target_pos - player_pos
	var rotTransform = t.looking_at(target_pos,Vector3(0,1,0))
	var thisRotation = Quat(t.basis).slerp(rotTransform.basis,value*0.1)
	value += get_fixed_process_delta_time()
	player.set_transform(Transform(thisRotation,t.origin))	
	player_pos = player.get_global_transform().origin
	helper_pos = helper.get_global_transform().origin	
	playerFacing = (helper_pos - player_pos).normalized()

func _input(event):
	if hover_node and hover_node.get_name() == "phone":	
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed():
			no_move_on_click = true
			phone_opened = true
			hide_ui_icons()
			ui_hide_show(get_node("ui_elements/ui_phone"), Vector2(0,-1310), Tween.TRANS_QUAD, Tween.EASE_OUT)

#determine where on Area we click and indicate that player should move there by is_moving = true
func _on_Area_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if !blocking_ui:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed and no_move_on_click == false:
			is_moving = true
			value = 0 
			player_pos = player.get_global_transform().origin
			helper_pos = helper.get_global_transform().origin
			target_pos = click_pos
			
	else:
		#need to add this so player doesn´t move when exiting dialog
		direction = Vector3(0,0,0)

#the below functions handle hover animations for UI icons. This could probably be handled more efficiently in one generic function, not sure how
func _on_phone_mouse_enter():
	ui_hover("phone", get_node("ui_elements/phone/Sprite"), Vector2(1.1, 1.1), true)
	hover_node = get_node("ui_elements/phone")

func _on_phone_mouse_exit():
	ui_hover("", get_node("ui_elements/phone/Sprite"), Vector2(1.0, 1.0), false)
	hover_node = null

func _on_schoolbag_mouse_enter():
	ui_hover("school bag", get_node("ui_elements/schoolbag/Sprite"), Vector2(1.1, 1.1), true)
	hover_node = get_node("ui_elements/schoolbag")

func _on_schoolbag_mouse_exit():
	ui_hover("", get_node("ui_elements/schoolbag/Sprite"), Vector2(1.0, 1.0), false)
	hover_node = null

func _on_map_mouse_enter():
	ui_hover("map", get_node("ui_elements/map/Sprite"), Vector2(1.1, 1.1), true)
	hover_node = get_node("ui_elements/map")

func _on_map_mouse_exit():
	ui_hover("", get_node("ui_elements/map/Sprite"), Vector2(1.0, 1.0), false)
	hover_node = null

func _on_calendar_mouse_enter():
	ui_hover("calendar", get_node("ui_elements/calendar/Sprite"), Vector2(1.1, 1.1), true)
	hover_node = get_node("ui_elements/calendar")
		
func _on_calendar_mouse_exit():
	ui_hover("calendar", get_node("ui_elements/calendar/Sprite"), Vector2(1.0, 1.0), false)
	hover_node = null

#play effects when hovering over UI icons
func ui_hover(name, gui_node, scale, move):
	label_hotspot.set_text(name)
	no_move_on_click = move
	effect_ui_hover.interpolate_property (gui_node, "transform/scale", gui_node.get_scale(), scale, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	effect_ui_hover.start()

#hide or show UI icons when calling blocking UI elements, like phone, map or schoolbag
func ui_hide_show(gui_node, move_delta, method1, method2):
	effect_ui_hide_show.interpolate_property (gui_node, "transform/pos", gui_node.get_pos(), gui_node.get_pos() + move_delta, 1, method1, method2)
	effect_ui_hide_show.start()

#combine two below functions into toggle_ui_icons(delta)
func hide_ui_icons():
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0,200), Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func unhide_ui_icons():
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0,-200), Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		
func _look_at(text):
	label_hotspot.set_text(text)
