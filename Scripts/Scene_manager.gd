extends Node2D

var next_scene = "VehicleWheel3D"

func _ready():
	pass

func transitionToScene(new_scene: String):
	next_scene = new_scene
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")

func finished_fading():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(next_scene)
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")
