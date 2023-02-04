extends Area3D

var dir = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	translation -= transform.basis.x * 150 * delta


func _on_timer_timeout():
	queue_free()

func _on_body_entered(body:Node3D):
	if body.is_in_group("Player"):
		body.take_damage(10)

	queue_free()
