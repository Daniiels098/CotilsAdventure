extends Node2D

@onready var anim_C = $AnimationPlayer

func _process(delta):
	anim_C.play("anim_C")
