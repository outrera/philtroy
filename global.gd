extends Node

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
	"event": {"name": "start", "stage": 1}}
	
var tempData = {}

var charData = {
	"ellie": {
	"dialogue": "res://dialogue/ellie.json", 
	"branch": "a"},
	"bobby": {
	"dialogue": "res://dialogue/bobby.json", 
	"branch": "a"},
	"sam": {
	"dialogue": "res://dialogue/sam.json", 
	"branch": "a"}
	}

func _ready():
	set_process(true)

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
#	file.close()

func goto_scene(scene):
    get_tree().change_scene("res://"+scene)