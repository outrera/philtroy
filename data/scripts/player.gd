extends KinematicBody

var value = 0
var curpos
var startpos
var direction
var player_speed = 7
var click_pos
var distance_to_target

#flags/states
var is_moving = false
var isRotating = false
var no_move_on_click = false
var blocking_ui = false
var dialogue_running = false
var phone_opened = false
	
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


func _on_Area_input_event( camera, event, click_pos, click_normal, shape_idx ):
	pass


func _on_scene_input_event( camera, event, click_pos, click_normal, shape_idx ):
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
