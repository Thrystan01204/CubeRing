extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	var anim = $CanvasLayer/AnimationPlayer
	anim.play_backwards("fade_in")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://Arena/Arena.tscn")
