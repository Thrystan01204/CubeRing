extends RigidBody3D

var shoot = false
var damage = 10
const speed = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z)


func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= damage
		queue_free()
	else:
		queue_free()
