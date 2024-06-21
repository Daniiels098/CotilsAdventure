extends Area2D

@onready var sprite = $Sprite2D2
@onready var anim_player = $AnimationPlayer
@export var next_scene_path = ""

func _ready():
	sprite.visible = true
	var player = find_parent("CurrentScene").get_children().back().get_node("Player")
	player.connect("player_entering_door", enter_door)
	player.connect("player_entered_door", close_door)

func enter_door():
	anim_player.play("opening")

func close_door():
	anim_player.play("closing")

func door_closed():
	#get_tree().change_scene_to_file(next_scene_path)
	get_node("/root/CenaManager").transitionToScene(next_scene_path)
