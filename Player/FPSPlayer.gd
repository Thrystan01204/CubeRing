class_name FPSPlayer

extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


@onready var camera : Camera3D = $Camera3D
@onready var player_animation : AnimationPlayer = $Player_model/AnimationPlayer

var look_sensivity = ProjectSettings.get_setting("Player/look_sensivity")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_camera() -> Camera3D :
	return $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if player_animation.current_animation == "idle":
			player_animation.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if player_animation.current_animation == "walk":
			player_animation.play("idle")

	move_and_slide()
	
	# Unlock mouse ?
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	

func _input(event):
	# Mouse Look
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensivity)
		camera.rotate_x(-event.relative.y * look_sensivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
