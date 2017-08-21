extends KinematicBody

var value = 0
var direction
var player_speed = 8
var click_pos

#flags/states
var is_moving = false
var isRotating = false
var no_move_on_click = false
	
onready var player = self
onready var target = Vector3(0,0,0)
onready var helper = self.get_node("rotation_helper/Position3D")
	
onready var target_pos = Vector3(0,0,0)
onready var player_pos = player.get_global_transform().origin
onready var helper_pos = helper.get_global_transform().origin	

var playerFacing

var movement = Vector3()

func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	#move and rotate player towards set target
	if isRotating:
		pass
	if global.is_moving:
		if !global.blocking_ui:
			turn_towards()
			#TODO: this kinda works, but not 100%. This should only be compared to on click distance to target, not all the time
			#TODO: also, if player has already turned towards target, turn_towards shouldn´t run. Causing glitches....
			#TODO: probably easily solved by running a timer on each move/rotate, no turn takes more than 1.5 secs
			if player_pos.distance_to(target_pos) > 3:
				player.move(playerFacing*get_fixed_process_delta_time()*3)
			if player_pos.distance_to(target_pos) < 0.5:
				global.is_moving = false
				print("stop")

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

#func _on_Area_input_event( camera, event, click_pos, click_normal, shape_idx ):
#	pass

func _on_scene_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if !global.blocking_ui:
		#for Godot 3.0 use if(event is InputEventMouseButton)
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed and global.blocking_ui == false:
			global.is_moving = true
			value = 0 
			player_pos = player.get_global_transform().origin
			helper_pos = helper.get_global_transform().origin
			target_pos = click_pos
			
	else:
		#need to add this so player doesn´t move when exiting dialog
		direction = Vector3(0,0,0)