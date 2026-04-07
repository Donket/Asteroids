extends CharacterBody2D

var speed = 50
var permanent = false
var bounds_tl: Vector2 = Vector2(-500, -420)
var bounds_br: Vector2 = Vector2(500, 80)
var direction = 0

func _physics_process(delta):
	if permanent:
		velocity = Vector2(speed*2*cos(-deg_to_rad(direction)), speed*2*sin(-deg_to_rad(direction)))
	move_and_slide()
	if deathCheck():
		if permanent:
			if abs(position.x) >= 530:
				direction = 540 - int(direction) % 360
				position.x = clamp(position.x, -529, 529)
			if position.y < -420 or position.y > 80:
				direction = 360 - direction
				position.y = clamp(position.y, -419, 79)
			return
		queue_free()


func deathCheck():
	var bounds = Vector4(bounds_tl.x, bounds_tl.y, bounds_br.x, bounds_br.y)
	if global_position.x < bounds[0] or global_position.x > bounds[2]:
		return true
	if global_position.y < bounds[1] or global_position.y > bounds[3]:
		return true
	return false


func kill():
	$AnimatedSprite2D.visible = false
	$CPUParticles2D.emitting = true
	await $CPUParticles2D.finished
	queue_free()
