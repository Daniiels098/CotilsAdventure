extends CharacterBody2D

signal player_entering_door
signal player_entered_door
signal camera_desapar

@export_category("Variables")
@export var walk_speed:float = 2.5
@export var initial_position = Vector2.ZERO
@export var input_direction = Vector2.ZERO
@export var is_moving:bool = false
@export var percent_moved:float = 0.0
@onready var rayPa = $RayParede
@onready var rayPo = $RayPorta
const TILE_SIZE = 16.0
@onready var anim_player = $AnimationPlayer
@onready var can_walk: bool = true

func _ready():
	initial_position = position

func _physics_process(delta):
	if !is_moving or !can_walk:
		player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

func player_input():
	if input_direction.y == 0:
		input_direction.x = Input.get_axis("move_left","move_right")
	if input_direction.x == 0:
		input_direction.y = Input.get_axis("move_up","move_down")
	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true
	
func entered_door():
	emit_signal("player_entered_door")

#func 

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
	
	var desired_step: Vector2 = input_direction*TILE_SIZE/2
	
	rayPa.target_position = desired_step
	rayPa.force_raycast_update()
	
	rayPo.target_position = desired_step
	rayPo.force_raycast_update()
	
	if rayPo.is_colliding():
		if percent_moved == 0.0:
			emit_signal("player_entering_door")
		percent_moved += walk_speed*delta
		if percent_moved >= 1.0:
			position = initial_position+(input_direction*TILE_SIZE)
			percent_moved = 0.0
			is_moving = false
			can_walk = false
			anim_player.play("desapar")
			emit_signal("player_entered_door")
			#emit_signal("camera_desapar")
		else:
			position = initial_position+(TILE_SIZE*input_direction*percent_moved)
	elif !rayPa.is_colliding():
		percent_moved += walk_speed*delta
		if percent_moved >= 1.0:
			position = initial_position+(TILE_SIZE*input_direction)
			percent_moved = 0.0
			is_moving = false
		else:
			position = initial_position+(TILE_SIZE*input_direction*percent_moved)
	else:
		is_moving = false
		percent_moved = 0.0
