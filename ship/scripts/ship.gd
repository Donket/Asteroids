extends CharacterBody2D

var bulletSpeed = 500
var target_pos = Vector2(0,0)
var attributes: set = changeAttributes


func changeAttributes(newAttributes):
	if !newAttributes.has_method("hurt"):
		$hp.visible = false
	attributes=newAttributes


func _physics_process(delta):
	if $"..".ended:
		return 
	move_rotate_towards(target_pos, delta, 5.0, 120.0, Vector2(-500,-300), Vector2(500,300))
	if attributes.has_method("hurt"):
		$hp.rotation = -rotation
	move_and_slide()


func _on_area_2d_body_entered(body):
	body.queue_free()


func move_rotate_towards(point: Vector2, delta: float, rotation_speed: float = 5.0, move_speed: float = 100.0, bounds_tl: Vector2 = Vector2(-500, -300), bounds_br: Vector2 = Vector2(500, 300)):
	var arrive_threshold := 2.0
	var facing_threshold := deg_to_rad(10.0)
	var to_target: Vector2 = point - global_position
	if to_target.length() <= arrive_threshold:
		velocity = Vector2.ZERO
		return
	var target_angle: float = to_target.angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	var diff = target_angle - rotation
	diff = fposmod(diff + PI, TAU) - PI
	var angle_diff = abs(diff)
	if angle_diff <= facing_threshold:
		velocity = Vector2(move_speed, 0).rotated(rotation)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	global_position.x = clamp(global_position.x, bounds_tl.x, bounds_br.x)
	global_position.y = clamp(global_position.y, bounds_tl.y, bounds_br.y)


func _on_timer_timeout():
	var to_center = (Vector2(0, 0) - position).normalized() * 150
	var random_offset = Vector2(randi_range(-150, 150), randi_range(-150, 150))
	target_pos = position + to_center + random_offset


func _on_area_2d_area_entered(area):
	if randi_range(0,3) > 0:
		return
	var bullet_speed = 500.0
	var shooter_pos = position
	var target_pos = area.get_parent().position
	var target_vel = area.get_parent().velocity
	var r = target_pos - shooter_pos
	var a = target_vel.dot(target_vel) - bullet_speed * bullet_speed
	var b = 2.0 * r.dot(target_vel)
	var c = r.dot(r)
	var discriminant = b * b - 4.0 * a * c
	var direction : Vector2
	if discriminant < 0.0:
		direction = r.normalized()
	else:
		var sqrt_disc = sqrt(discriminant)
		var t1 = (-b + sqrt_disc) / (2.0 * a)
		var t2 = (-b - sqrt_disc) / (2.0 * a)
		var t = min(t1, t2)
		if t < 0.0:
			t = max(t1, t2)
		if t < 0.0:
			direction = r.normalized()
		else:
			var intercept_point = target_pos + target_vel * t
			direction = (intercept_point - shooter_pos).normalized()
	var bullet = load("res://ship/scenes/bullet.tscn").instantiate()
	bullet.velocity = direction * bullet_speed
	bullet.position = shooter_pos
	bullet.rotation = direction.angle()
	get_parent().call_deferred("add_child",bullet)


func _on_redraw_targets_timeout():
	$Area2D.monitoring = false
	$Area2D.monitoring = true
