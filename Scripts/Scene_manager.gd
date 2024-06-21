extends Node2D

@onready var next_scene = load("res://scenes/Salas_Aula/sala_azul.tscn")

func _ready():
	pass

func transitionToScene(new_scene: Object):
	#next_scene = new_scene
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")

func finished_fading():
	var instance = next_scene.instantiate()
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(instance)
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")
