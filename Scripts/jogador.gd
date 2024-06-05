extends CharacterBody2D

@export_category("Variables")
@export var walk_speed:float = 2.0
@export var initial_position = Vector2.ZERO
@export var input_direction = Vector2.ZERO
@export var is_moving:bool = false
@export var percent_moved:float = 0.0
@onready var rayPa = $RayParede
@onready var rayPo = $RayPorta
const TILE_SIZE = 16.0
@onready var anim_player = $AnimationPlayer


func _ready():
	initial_position = position

func _physics_process(delta):
	if  is_moving == false:
		player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

func player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true
	
func move(delta):
	if Input.is_anything_pressed():
			if input_direction.y > 0:
				anim_player.play("WalkDown")
			elif input_direction.x > 0:
				anim_player.play("WalkRight")
			elif input_direction.x < 0:
				anim_player.play("WalkLeft")
			elif input_direction.y < 0:
				anim_player.play("WalkUp")
			#if Input.is_action_just_released("move_down"):
			#	anim_player.play("Down")
			#elif Input.is_action_just_released("move_right"):
			#	anim_player.play("Right")
			#elif Input.is_action_just_released("move_left"):
			#	anim_player.play("Left")
			#elif Input.is_action_just_released("move_up"):
			#	anim_player.play("Up")
	
	var desired_step: Vector2 = input_direction*TILE_SIZE/2
	
	rayPa.target_position = desired_step
	rayPa.force_raycast_update()
	
	rayPo.target_position = desired_step
	rayPo.force_raycast_update()
	
	if !rayPa.is_colliding():
		percent_moved += walk_speed * delta
		if percent_moved >= 1.0:
			position = initial_position+(TILE_SIZE*input_direction)
			percent_moved = 0.0
			is_moving = false
		else:
			position = initial_position+(TILE_SIZE*input_direction*percent_moved)
	else:
		is_moving = false
