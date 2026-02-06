extends CharacterBody2D

var bulletSpeed = 500
var target_pos = Vector2(0,0)
var attributes: set = changeAttributes
var moveSpeed = 120
var rotationSpeed = 5.0
var hp = 200: set = hurt
var asteroidsInRange = []
var readyForShot = false

@onready var damageLabel = preload("res://ship/scenes/ship_damage_label.tscn")

func _ready():
	$shootTimer.wait_time = 2 - min(1/6*Global.turn+1/10*Global.starsDeck.size(),1.95)

func hurt(newHp):
	if newHp < hp:
		var scene = damageLabel.instantiate()
		scene.get_node("label").text = str(hp-newHp)
		$hp.add_child(scene)
	hp=newHp
	$hp/hpbar.value = newHp

func changeAttributes(newAttributes):
	if !newAttributes.has_method("hurt"):
		$hp.visible = false
	attributes=newAttributes

func _physics_process(delta):
	if $"..".ended:
		return 
	
	move_rotate_towards(target_pos, delta, rotationSpeed, moveSpeed, Vector2(-500,-300), Vector2(500,300))
	
	if attributes.has_method("hurt"):
		$hp.rotation = -rotation
	move_and_slide()

func _on_area_2d_body_entered(body):
	body.queue_free()

func move_rotate_towards(point, delta, rotation_speed, move_speed, bounds_tl, bounds_br):
	var to_target = point - global_position
	
	if to_target.length() > 5.0:
		var target_angle = to_target.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		var forward_vel = Vector2(move_speed, 0).rotated(rotation)
		velocity = velocity.lerp(forward_vel, rotation_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * delta)

	global_position.x = clamp(global_position.x, bounds_tl.x, bounds_br.x)
	global_position.y = clamp(global_position.y, bounds_tl.y, bounds_br.y)

func _on_timer_timeout():
	var random_offset = Vector2(randf_range(-300, 300), randf_range(-300, 300))
	target_pos = position + random_offset
	target_pos.x = clamp(target_pos.x, -500, 500)
	target_pos.y = clamp(target_pos.y, -400, 60)


func shoot(target):
	if randi_range(0,max(0,3-floor(Global.turn/2))) > 0:
		return
	var bullet_speed = 500.0
	var shooter_pos = position
	var target_pos = target.position
	var target_vel = target.velocity
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
	if direction == Vector2(0,0):
		direction = Vector2.RIGHT.rotated(rotation)
	
	direction *= randf_range(0.9,1.1)
	
	var bullet = load("res://ship/scenes/bullet.tscn").instantiate()
	bullet.velocity = direction * bullet_speed
	bullet.position = shooter_pos
	bullet.rotation = direction.angle()
	get_parent().call_deferred("add_child",bullet)
	if Global.turn >= 6:
		var count = floor(Global.turn/2)-2
		var spreadAngle = deg_to_rad(30.0)
		var step = spreadAngle/max(1, count)
		for i in range(count):
			var offsetIndex = i - (count - 1) / 2.0
			var angleOffset = offsetIndex * step
			var spreadDirection = direction.rotated(angleOffset)

			bullet = load("res://ship/scenes/bullet.tscn").instantiate()
			bullet.velocity = spreadDirection * bullet_speed
			bullet.position = shooter_pos
			bullet.rotation = spreadDirection.angle()
			get_parent().call_deferred("add_child", bullet)


func _on_redraw_targets_timeout():
	$Area2D.monitoring = false
	$Area2D.monitoring = true


func _on_area_2d_area_entered(area):
	asteroidsInRange.append(area.get_parent())
	if readyForShot:
		shoot(area.get_parent())

func _on_area_2d_area_exited(area):
	asteroidsInRange.erase(area.get_parent())

func refreshAsteroids():
	var newAsteroids = []
	for i in asteroidsInRange:
		if i == null or not is_instance_valid(i):
			newAsteroids.append(i)
	asteroidsInRange = newAsteroids

func _on_shoot_timer_timeout():
	refreshAsteroids()
	if asteroidsInRange.size() > 0:
		readyForShot = false
		var closest = asteroidsInRange[0]
		var closestDistance = position.distance_to(asteroidsInRange[0].position)
		for asteroid in asteroidsInRange:
			var distance = position.distance_to(asteroid.position)
			if distance < closestDistance:
				closest = asteroid
				closestDistance = distance
		shoot(closest)
	else:
		readyForShot = true
