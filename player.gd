extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var dash_dist = 5
var damage = 100

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var aimcast =$Head/Camera3D/AimCast
@onready var head := $Head
@onready var camera := $Head/Camera3D
@onready var core := $Head/Camera3D/Hand/Core
@onready var fire_ball = preload("res://fire_ball.tscn")

#signal shoot(fire_ball, direction, location)
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
			
func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * 0.0005)
			camera.rotate_x(-event.relative.y * 0.0005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
	
#	if event is InputEventMouseButton:
#		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
#			shoot.emit(fire_ball, rotation, position)

func _physics_process(delta):
	#look_at(aimcast.get_collision_point(),Vector3.UP)
	# Add the gravity.
	#if Input.is_action_just_pressed("fire_ball"):
	#	if aimcast.is_colliding():
			#var fire_ball = get_world_3d().direct_space_state
			#var params = PhysicsRayQueryParameters3D.new()
			#params.from = core.global_transform.origin
			#params.to = aimcast.get_collision_point()
			#var collision = fire_ball.intersect_ray(params)
			#if collision:
			#	var target = collision.collider
			#var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position,
		#$Camera3D.global_position - $Camera3D.global_transform.basis.z * 100)
			#var collision = space.intersect_ray(query)
			#if collision:
			#	var target = collision.collider	
			#	if target.is_in_group("enemy"):
			#		print("hit enemy")
			#		target.health -= damage
	if  Input.is_action_just_pressed("fire_ball"):
		#if aimcast.is_colliding():
			var space_state = get_world_3d().direct_space_state
			var params = PhysicsRayQueryParameters3D.new()
			var result = space_state.intersect_ray(params)
			var f = fire_ball.instantiate()
			core.add_child(f)
			f.look_at(to,Vector3.UP)
			f.shoot = true
	#var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position,
		#$Camera3D.global3D_position - $Camera3D.global3D_transform.basis.z * 100)
		#var collision = fire_ball.intersect_ray(query)
		#if collision:
		#	var target = collision.collider	
		#	if target.is_in_group("enemy"):
		#		print("hit enemy")
		#		target.health -= damage
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("left"):
		transform.origin -= head.transform.basis.x * 0.15
		if Input.is_action_just_pressed("dash"):
			translate((head.transform.basis * Vector3(-dash_dist, 0, 0)))
	if Input.is_action_pressed("right"):
		transform.origin += head.transform.basis.x * 0.15
		if Input.is_action_just_pressed("dash"):
			translate((head.transform.basis * Vector3(dash_dist, 0, 0)))
	if Input.is_action_pressed("forward"):
		transform.origin -= head.transform.basis.z * 0.15
		if Input.is_action_just_pressed("dash"):
			translate((head.transform.basis * Vector3(0, 0, -dash_dist)))
	if Input.is_action_pressed("backward"):
		transform.origin += head.transform.basis.z* 0.15
		if Input.is_action_just_pressed("dash"):
			translate((head.transform.basis * Vector3(0, 0, dash_dist)))
	#var input_dir = Input.get_vector("left", "right", "forward", "backward")
	#var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
	#	velocity.x = direction.x * SPEED
	#	if Input.is_action_just_pressed("dash"):
	#		translate(direction.x)
	#	velocity.z = direction.z * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	#	velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
