extends Node3D

@onready var intro_anim : AnimationPlayer = $Intro
@onready var player : FPSPlayer = $FPSPlayer
@onready var intro_cam : Camera3D = $Camera3D
@onready var music_player : AudioStreamPlayer = $AudioStreamPlayer
@onready var boss_anim : AnimationPlayer = $Boss_model/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	intro_cam.make_current()
	player.set_process(false)
	player.set_process_input(false)
	intro_anim.play("introduction")
	await intro_anim.animation_finished
	player.start()
	player.set_process(true)
	player.set_process_input(true)
	player.get_camera().make_current()
	boss_anim.play("Idle_flying") # TODO : Enable boss AI instead
