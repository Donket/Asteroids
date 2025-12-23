extends CharacterBody2D


func _physics_process(delta):
	move_and_slide()
	if abs(position.x) >= 650 or abs(position.y) >= 450:
		queue_free()
