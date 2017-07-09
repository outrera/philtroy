extends Node

var game_data = {}
var curpos
var startpos
var target
var direction
var player_speed = 7
var click_pos
var distance_to_target
var hover_node = null
var num_replies = 0
var dialog_branch = null
var dialog_pos
var npc_dialogue

#flags/states
var is_moving = false
var no_move_on_click = false
var blocking_ui = false
var dialogue_running = false
var phone_opened = false

#get some nodes for easy access
onready var player = get_node("player")
onready var effect_ui_hover = get_node("effects/ui_hover")
onready var effect_ui_hide_show = get_node("effects/ui_hide_show")
onready var label_hotspot = get_node("ui_elements/Label_hotspot")

#load some asset scenes
onready var dialog_panel = load("res://asset scenes/dialog_window.tscn")
onready var reply_button = load("res://asset scenes/reply.tscn")

onready var viewsize = get_viewport().get_rect().size

#set character start dialogues
var ellie = {"dialogue": "res://dialogue/ellie_start.json", "branch": "a"}

func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	for object in get_node("objects").get_children():
		object.connect("look_at", self, "_look_at")
	for object in get_node("npcs").get_children():
		object.connect("dialogue", self, "_talk_to")
		object.connect("look_at", self, "_look_at")

func _process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_quit"):
		get_tree().quit()
	#if dialogue is running and we press ui_exit, exit dialogue and delete dialogue nodes
	if dialogue_running == true:
		if Input.is_action_pressed("ui_exit"):
			kill_dialogue()
	if phone_opened == true:
		if Input.is_action_pressed("ui_exit"):
			no_move_on_click = false
			phone_opened = false
			ui_hide_show(get_node("ui_elements/ui_phone"), Vector2(0,1310), Tween.TRANS_QUAD, Tween.EASE_OUT)
			unhide_ui_icons()
	
func _fixed_process(delta):
	#move player to mouse position
	#TODO: make player turn smoother
	if is_moving:
		if !blocking_ui:
			player.move(direction * player_speed * delta)
			curpos = player.get_global_transform().origin
			if curpos.distance_to(startpos) > distance_to_target:
				is_moving = false

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
			curpos = player.get_global_transform().origin
			startpos = curpos
			player.look_at(click_pos, Vector3(0,1,0))
			direction = (click_pos - curpos).normalized()
			distance_to_target = curpos.distance_to(click_pos)
			is_moving = true
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

#dynamically load the json for character dialogue
func load_json(json, type):
	var file = File.new();
	file.open(json[type], File.READ);
	game_data.parse_json(file.get_as_text())	

func start_dialogue(json,pos):
	load_json(json, "dialogue")
	
	num_replies = game_data["dialogue"][json["branch"]]["responses"].size()

	dialogue_window()
	
	#load and display character talk animation
	var sprite = Sprite.new()
#	sprite = sprite.instance()
	sprite.set_texture(load("res://graphics/" + game_data["animation"]))
	sprite.set_pos(Vector2(300,650))
	get_node("ui_elements/ui_dialogue").add_child(sprite)
	
	#set text and reply in dialog panel
	get_node("ui_elements/ui_dialogue/panel/text").set_text(game_data["dialogue"][ellie["branch"]]["text"])
	for n in range(0,num_replies):
		get_node("ui_elements/ui_dialogue/reply" + str(n+1)).set_text(game_data["dialogue"][json["branch"]]["responses"][n]["reply"])
	
#setup the character dialogue panel
#TODO: consider one function to position and size panels and labels dynamically instead
func dialogue_window():
	if dialogue_running == false:
		hide_ui_icons()
	dialogue_running = true
	var reply_offset = 0
	var labels = ["panel","dialogue"]
	for n in range(num_replies):
		labels.push_back("reply" + str(n+1))
	
	var dialog = {"width": 800, "height": 100, "posx": 400, "posy": 370}
	
	#first kill all existing reply nodes
	if get_node("ui_elements/ui_dialogue").get_child_count() > 0:
		for child in get_node("ui_elements/ui_dialogue").get_children():
			child.set_name("deleted")
			child.queue_free()

	new_label(labels)

	get_node("ui_elements/ui_dialogue/panel").set_size(Vector2(dialog.width, dialog.height + num_replies*30))
	get_node("ui_elements/ui_dialogue/panel").set_pos(Vector2(viewsize.x/2 - dialog.posx, viewsize.y - dialog.posy))
	get_node("ui_elements/ui_dialogue/panel").set_opacity(0.5)
	
	for n in range(num_replies):
		get_node("ui_elements/ui_dialogue/reply" + str(n+1)).set_size(Vector2(400, 50))
		get_node("ui_elements/ui_dialogue/reply" + str(n+1)).set_pos(Vector2(viewsize.x/2 - 390, viewsize.y - 280 + reply_offset))
		get_node("ui_elements/ui_dialogue/reply" + str(n+1)).num_reply = n
		reply_offset += 30

	reply_offset = 0
	
#create new labels and add them as children of the ui_dialogue container
func new_label(labels):

	for lbl in labels:
		if lbl == "panel":
			var node = dialog_panel.instance()
			node.set_name(lbl)
			get_node("ui_elements/ui_dialogue").add_child(node)
		else:
			var node = reply_button.instance()
			node.set_name(lbl)
			node.connect("reply_selected",self,"_pick_reply",[], CONNECT_ONESHOT)
			get_node("ui_elements/ui_dialogue").add_child(node)

func hide_ui_icons():
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0,200), Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func unhide_ui_icons():
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0,-200), Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	
func kill_dialogue():
	for x in get_node("ui_elements/ui_dialogue").get_children():
		x.queue_free()
	unhide_ui_icons()
	dialogue_running = false
	blocking_ui = false
		
func _pick_reply(n):
	if game_data["dialogue"][ellie["branch"]]["responses"][n]["next"] != "exit":
		ellie["branch"] = game_data["dialogue"][ellie["branch"]]["responses"][n]["next"]
		start_dialogue(ellie, dialog_pos)
	else:
		kill_dialogue()
		
func _look_at(text):
	label_hotspot.set_text(text)

func _talk_to(dialogue, branch):
	label_hotspot.set_text("talking to NPC")
	npc_dialogue = {"dialogue": dialogue, "branch": branch}
	start_dialogue(npc_dialogue,dialog_pos)