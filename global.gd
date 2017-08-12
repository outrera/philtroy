extends Node

var day
var time
var scene

var tempData = {}
var sceneData = {}

var blocking_ui = false
var is_moving = false

#let´s make this a json loaded at ready, so as to not clutter the script
var gameData = {
	"milk": 0, 
	"cookies": 0, 
	"day": 1, 
	"month": [
		"january",
		"february",
		"march",
		"april",
		"may",
		"june",
		"july",
		"august",
		"september",
		"oktober",
		"november",
		"december",
	],
	"weekday": [
		"monday",
		"tuesday",
		"wednesday",
		"thursday",
		"friday",
		"saturday",
		"sunday"], 
	"time": [
		"morning",
		"noon",
		"evening",
		"night"
	], 
	"event": {"name": "start", "stage": 1},
	"scene": "schoolyard.tscn"}

var charData = {
	"ellie": {
	"dialogue": "res://data/dialogue/ellie.json", 
	"branch": "a"},
	"bobby": {
	"dialogue": "res://data/dialogue/bobby.json", 
	"branch": "a"},
	"sam": {
	"dialogue": "res://data/dialogue/sam.json", 
	"branch": "a"}
	}

var locations = [
	"schoolyard",
	"schoolhall",
	"myroom"]

func _ready():
	set_process(true)
	for location in locations:
		print("loading")
		sceneData[location] = load_json("res://data/locations/location_" + location + ".json")
	day = "monday"
	time = "morning"

func _process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_quit"):
		get_tree().quit()

func load_json(json):
	var file = File.new()
	file.open(json, File.READ)
	tempData.parse_json(file.get_as_text())
	return tempData
	file.close()
	#for Godot 3.0
#	var file = File.new()
#	file.open(json, File.READ)
#	tempData = parse_json(file.get_as_text())

func goto_scene(scene):
    get_tree().change_scene("res://"+scene)

func load_scene(name):
	var gameRoot = get_tree().get_root().get_node("Node")
	
	for child in gameRoot.get_node("scene").get_children():
		child.set_name("DELETED")
		child.queue_free()
	for child in gameRoot.get_node("npcs").get_children():
		child.set_name("DELETED")
		child.queue_free()
		
	var scene = load("res://data/locations/" + name + ".tscn")
	scene = scene.instance()
	gameRoot.get_node("scene").add_child(scene)
	
	var location = sceneData[name][day][time]
	
	if location.has("actors"):
		for name in location["actors"].keys():
			var pos = location["actors"][name]["pos"]
			global.charData[name]["dialogue"] = location["actors"][name]["dialogue"]
			var actor = load("res://data/npcs/" + name + ".tscn")
			#pose > animation? For now use base animation.
			actor = actor.instance()
			actor.set_translation(Vector3(pos.x,pos.y, pos.z))
			actor.set_name(name)
			gameRoot.get_node("npcs").add_child(actor)

	if location.has("objects"):
		for object in location["objects"].keys():
			var pos = location["objects"][object]["pos"]
			var object = load("res://data/objects/" + name + ".tscn")
			object.set_pos(Vector3(pos.x, pos.y, pos.z))
			object.set_name(name)
			get_node("objects").add_child(object)
	
	#animate scene transition somehow(time label swapped with animation?)
	#how to handle scene specific cameras?