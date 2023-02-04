extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var dash_dist = 1
var damage = 100


@onready var aimcast = $Head/Camera3D/AimCast
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var head := $Head
@onready var camera := $Head/Camera3D
@onready var core := $Head/Hand/Core
@onready var fire_ball = preload("res://fire_ball.tscn")

func _unhandled_input(event):
	
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * 0.001)
			camera.rotate_x(-event.relative.y * 0.001)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if Input.is_action_just_pressed("fire"):
		if aimcast.is_colliding():
			var fire_ball = get_world_3d().direct_space_state
			var params = PhysicsRayQueryParameters3D.new()
			params.from = core.global_transform.origin
			params.to = aimcast.get_collision_point()
			var collision = fire_ball.intersect_ray(params)
			if collision:
				var target = collision.collider
				
				if target.is_in_group("enemy"):
					print("hit enemy")
					target.health -= damage
	#if  Input.is_action_just_pressed("fire"):
	#		if aimcast.is_colliding():
	#			var f = fire_ball.instantiate()
	#			core.add_child(f)
	#			f.look_at(aimcast.get_collision_point(),Vector3.UP)
				
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
