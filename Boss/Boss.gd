extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var anim = $AnimationPlayer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))

	velocity = Vector3.FORWARD * SPEED
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _physics_process(delta):
	move_and_slide()

func _process(delta):
	look_at(target.position, Vector3.UP)

	if (target.position < 5):
		anim.play("smash")
	else:
		anim.play("Idle_flying")

func _on_smash_area_entered(area:Area3D):
	if area.is_in_group("player"):
		area.take_damage()
