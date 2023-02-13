extends RigidBody3D

var shoot = false
const damage = 100
const speed = 10

func _ready():
	top_level = true

var velocity = Vector3.ZERO

#func _physics_process(delta):
#	position += velocity * delta

func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z,-transform.basis.z * speed)

func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= damage
		queue_free()
	else:
		queue_free()
