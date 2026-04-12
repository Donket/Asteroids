extends CharacterBody2D

var speed = 50
var permanent = false
var bounds_tl: Vector2 = Vector2(-500, -420)
var bounds_br: Vector2 = Vector2(500, 80)
var direction = 0
var isSaw = false

func _physics_process(delta):
	if permanent:
		velocity = Vector2(speed*2*cos(-deg_to_rad(direction)), speed*2*sin(-deg_to_rad(direction)))
	move_and_slide()
	if deathCheck():
		if permanent:
			if abs(global_position.x) >= 530:
				direction = 540 - int(direction) % 360
				global_position.x = clamp(global_position.x, -529, 529)
			if global_position.y < -420 or global_position.y > 80:
				direction = 360 - direction
				global_position.y = clamp(global_position.y, -419, 79)
			return
		if isSaw:
			kill()
		else:
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
