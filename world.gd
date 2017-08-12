extends Node

var clickPos
var hoverNode = null

#flags/states
var isMoving = false
var isRotating = false
var noMoveOnClick = false
var blockingUI = false
var dialogueRunning = false

var day = 0
var time = 0
var month = 6
var monthDays = 1

var sceneData = {}

onready var effectHoverUI = get_node("effects/tween")
onready var effectToggleUI = get_node("effects/tween")
onready var descriptionLabel = get_node("ui/descriptionLabel")

onready var viewsize = get_viewport().get_rect().size

var phoneOpen = false
var schoolbagOpen = false
var mapOpen = false
var calendarOpen = false

onready var phoneHidePos
onready var phoneShowPos
onready var schoolbagHidePos = get_node("ui/schoolbag_ui").get_pos()
onready var schoolbagShowPos
onready var mapHidePos
onready var mapShowPos
onready var calendarHidePos
onready var calendarShowPos

onready var uiIconsShowPos = get_node("ui/map").get_pos().y
onready var uiIconsHidePos = uiIconsShowPos + 200

func _ready():

	schoolbagShowPos = schoolbagHidePos - Vector2(0, 1000)
	phoneHidePos = get_node("ui/phone_ui").get_pos()
	phoneShowPos = phoneHidePos - Vector2(0, 1310)	
	mapHidePos = get_node("ui/map_ui").get_pos()
	mapShowPos = mapHidePos - Vector2(0, 1000)
	calendarHidePos = get_node("ui/calendar_ui").get_pos()
	calendarShowPos =  calendarHidePos - Vector2(0, 1000)
	
	set_process(true)
	set_process_input(true)
		
	get_node("ui/dateLabel").set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day])
	
	global.scene = "res://data/locations/location_schoolyard.json"
	sceneData = global.load_json(global.scene)
	global.load_scene("schoolyard")
	
	connect()
	
func connect():
	for object in get_node("objects").get_children():
		object.connect("look_at", self, "_look_at")
	for object in get_node("npcs").get_children():
		object.connect("look_at", self, "_look_at")
	for object in get_node("npcs").get_children():
		object.connect("dialogue", get_node("dialogue"), "_talk_to")

func _process(delta):
	#if dialogue is running and we press ui_exit, exit dialogue and delete dialogue nodes
	if Input.is_action_pressed("ui_exit"):
		if dialogueRunning == true:
			kill_dialogue()
		if phoneOpen == true:	
			global.blocking_ui = false
			phoneOpen = false
			var positionDelta = phoneHidePos - get_node("ui/phone_ui").get_pos()
			ui_hide_show(get_node("ui/phone_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
			toggle_ui_icons("show")
		if schoolbagOpen == true:	
			global.blocking_ui = false
			schoolbagOpen = false
			var positionDelta = schoolbagHidePos - get_node("ui/schoolbag_ui").get_pos()
			ui_hide_show(get_node("ui/schoolbag_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
			toggle_ui_icons("show")
		if mapOpen == true:	
			global.blocking_ui = false
			mapOpen = false
			var positionDelta = mapHidePos - get_node("ui/map_ui").get_pos()
			ui_hide_show(get_node("ui/map_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
			toggle_ui_icons("show")
		if calendarOpen == true:	
			global.blocking_ui = false
			calendarOpen = false
			var positionDelta = calendarHidePos - get_node("ui/calendar_ui").get_pos()
			ui_hide_show(get_node("ui/calendar_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
			toggle_ui_icons("show")

func _input(event):
	if hoverNode:
		if hoverNode.get_name() == "phone":	
			#for Godot 3.0 use if(event is InputEventMouseButton)
			if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed():
				global.blocking_ui = true
				phoneOpen = true
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").get_pos() - phoneShowPos
				ui_hide_show(get_node("ui/phone_ui"), Vector2(-positionDelta), Tween.TRANS_QUAD, Tween.EASE_OUT)
		if hoverNode.get_name() == "schoolbag":	
			#for Godot 3.0 use if(event is InputEventMouseButton)
			if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed():
				global.blocking_ui = true
				schoolbagOpen = true
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").get_pos() - schoolbagShowPos
				ui_hide_show(get_node("ui/schoolbag_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
		if hoverNode.get_name() == "map":	
			#for Godot 3.0 use if(event is InputEventMouseButton)
			if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed():
				global.blocking_ui = true
				mapOpen = true
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").get_pos() - mapShowPos
				ui_hide_show(get_node("ui/map_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
		if hoverNode.get_name() == "calendar":	
			#for Godot 3.0 use if(event is InputEventMouseButton)
			if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed():
				global.blocking_ui = true
				calendarOpen = true
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").get_pos() - calendarShowPos
				ui_hide_show(get_node("ui/calendar_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
		
		if hoverNode.get_name() == "calendar":	
			#for Godot 3.0 use if(event is InputEventMouseButton)
			if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed():
				time += 1
				if time == 4:
					time = 0
					day +=1
					monthDays += 1
					if day == 7:
						day = 0
					if monthDays > 30:
						monthDays = 1
						month += 1
						if month > 12:
							month = 0
				global.day = global.gameData["weekday"][day]
				global.time = global.gameData["time"][time]
				print("loading again!")
				global.load_scene("schoolyard")
				
				connect()
					
				get_node("ui/dateLabel").set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day])

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
	ui_hover("", get_node("ui/calendar/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null

#play effects when hovering over UI icons
func ui_hover(name, gui_node, scale, move):
	descriptionLabel.set_text(name)
	noMoveOnClick = move
	effectHoverUI.interpolate_property (gui_node, "transform/scale", gui_node.get_scale(), scale, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	effectHoverUI.start()

#hide or show UI icons when calling blocking UI elements, like phone, map or schoolbag
func ui_hide_show(gui_node, move_delta, method1, method2):
	effectToggleUI.interpolate_property (gui_node, "transform/pos", gui_node.get_pos(), gui_node.get_pos() + move_delta, 0.5, method1, method2)
	effectToggleUI.start()

func toggle_ui_icons(toggle):
	var startPos = get_node("ui/map").get_pos().y
	var positionDelta
	if toggle == "show":
		positionDelta = uiIconsShowPos - startPos
	if toggle == "hide":
		positionDelta = uiIconsHidePos - startPos
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0, positionDelta), Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func _look_at(text):
	descriptionLabel.set_text(text)
