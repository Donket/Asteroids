extends CharacterBody2D

var bulletSpeed = 500
var target_pos = Vector2(0,0)
var attributes: set = changeAttributes
var moveSpeed = 120
var rotationSpeed = 5.0
var hp = 200: set = hurt
var asteroidsInRange = []
var readyForShot = false
var shootingDisabled = false
var phase = 1: set = phaseChange
var bossPhase = 0: set = changeBossPhase
var bossPhaseFrozen = true
var permSaws = []

@onready var damageLabel = preload("res://ship/scenes/ship_damage_label.tscn")
@onready var maxHp = $hp/hpbar.max_value
@export var bounds_tl: Vector2 = Vector2(-500, -420)
@export var bounds_br: Vector2 = Vector2(500, 80)

func _ready():
	getPhase()
	$shootTimer.wait_time = 2 - min(1/4*Global.turn,0.95)
	if phase == 3:
		await get_tree().create_timer(0.5).timeout
		bossPhaseFrozen = false

func getPhase():
	phase = floor(Global.wins/3)

func phaseChange(newPhase):
	if newPhase == 1:
		scale = Vector2(1,1)
		$Sprite2D.animation = "ship2"
		$CollisionShape2D.shape.size=Vector2(20,20)
		$CollisionShape2D.position = Vector2(0,0)
		$shootTimer.wait_time *= 0.75
		bulletSpeed *= 1.5
	
	if newPhase == 2:
		scale = Vector2(1.5,1.5)
		$Sprite2D.animation = "ship3"
		$CollisionShape2D.shape.size=Vector2(20,40)
		$CollisionShape2D.position = Vector2(0,0)
		$shootTimer.wait_time *= 0.6
		bulletSpeed *= 1.75
		moveSpeed /= 3
	
	if newPhase == 3:
		scale = Vector2(2,2)
		$Sprite2D.animation = "boss"
		$CollisionShape2D.shape.size=Vector2(120,80)
		$CollisionShape2D.position = Vector2(0,10)
		$shootTimer.wait_time *= 0.4
		bulletSpeed *= 1
		$Area2D/CollisionShape2D.disabled = false
	
	phase = newPhase

func changeBossPhase(newBossPhase):
	if bossPhaseFrozen: return
	bossPhase = newBossPhase
	if bossPhase == 1:
		for i in range(3):
			var bullet = load("res://ship/scenes/sawblade.tscn").instantiate()
			bullet.direction = randf_range(0,360)
			bullet.position = position
			bullet.permanent = true
			bullet.isSaw = true
			bullet.scale *= Vector2(2,2)
			get_parent().call_deferred("add_child",bullet)
			permSaws.append(bullet)
	if bossPhase == 2:
		for saw in permSaws:
			saw.kill()
		bulletSpeed *= 3
		$shootTimer.wait_time /= 3
	if bossPhase == 3:
		for i in range(3):
			var bullet = load("res://ship/scenes/sawblade.tscn").instantiate()
			bullet.direction = randf_range(0,360)
			bullet.position = position
			bullet.permanent = true
			bullet.isSaw = true
			bullet.scale *= Vector2(2,2)
			get_parent().call_deferred("add_child",bullet)
			permSaws.append(bullet)

func bossShot():
	var asteroidArr = get_parent().asteroids
	if shootingDisabled or asteroidArr.size() == 0:
		return
	$shoot.playing = true
	var shooter_pos = position
	for target in asteroidArr:
		if target == null:
			continue
		var target_pos = target.position
		var target_vel = target.velocity
		var r = target_pos - shooter_pos
		var a = target_vel.dot(target_vel) - bulletSpeed * bulletSpeed
		var b = 2.0 * r.dot(target_vel)
		var c = r.dot(r)
		var discriminant = b * b - 4.0 * a * c
		var direction : Vector2
		if discriminant < 0.0 or abs(a) < 0.0001:
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
		
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT.rotated(rotation)
		
		direction *= randf_range(0.9, 1.1)
		
		var bullet = load("res://ship/scenes/bullet.tscn").instantiate()
		bullet.velocity = direction * bulletSpeed
		bullet.position = shooter_pos
		bullet.rotation = direction.angle()
		bullet.scale *= Vector2(2,2)
		get_parent().call_deferred("add_child", bullet)

func hurt(newHp):
	if newHp < hp:
		var scene = damageLabel.instantiate()
		scene.get_node("label").text = str(hp-newHp)
		$hp.add_child(scene)
	hp=newHp
	$hp/hpbar.value = newHp
	if phase == 3:
		checkBossPhase()

func checkBossPhase():
	if hp <= 2*maxHp/3 and bossPhase == 0:
		bossPhase = 1
	if hp <= maxHp/3 and bossPhase == 1:
		bossPhase = 2
	if hp <= maxHp/8 and bossPhase == 2:
		bossPhase = 3

func changeAttributes(newAttributes):
	if !newAttributes.has_method("hurt"):
		$hp.visible = false
	attributes=newAttributes

func _physics_process(delta):
	if $"..".ended:
		return 
	
	move_rotate_towards(target_pos, delta, rotationSpeed, moveSpeed)
	
	if attributes.has_method("hurt"):
		$hp.rotation = -rotation
	move_and_slide()

func _on_area_2d_body_entered(body):
	body.queue_free()

func move_rotate_towards(point, delta, rotation_speed, move_speed):
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
	target_pos = Vector2(999,999)
	while !isTargetPosValid():
		var random_offset = Vector2(randf_range(-300, 300), randf_range(-300, 300))
		target_pos = global_position + random_offset

func isTargetPosValid():
	var bounds = Vector4(bounds_tl.x, bounds_tl.y, bounds_br.x, bounds_br.y)
	if phase == 3:
		bounds += Vector4(100, 100, -100, -100)
	if target_pos.x < bounds[0] or target_pos.x > bounds[2]:
		return false
	if target_pos.y < bounds[1] or target_pos.y > bounds[3]:
		return false
	return true

func shoot(target):
	if shootingDisabled:
		return
		
	var bullet_speed = 500.0
	var bullet
	var isSaw = false
	if phase == 3 and randf_range(0,1) > 0.7:
		bullet = load("res://ship/scenes/sawblade.tscn").instantiate()
		bullet_speed = 150
		isSaw = true
	else:
		bullet = load("res://ship/scenes/bullet.tscn").instantiate()
	
	$shoot.playing = true
	var shooter_pos = global_position
	var target_pos = target.global_position
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
	
	bullet.velocity = direction * bullet_speed
	bullet.global_position = shooter_pos
	bullet.rotation = direction.angle()
	bullet.isSaw = isSaw
	if phase == 3:
		bullet.scale *= Vector2(2,2)
	get_parent().call_deferred("add_child",bullet)
	var count = max(0,floor(Global.turn/2)-1)
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
		if phase == 3:
			bullet.scale *= Vector2(2,2)
		get_parent().call_deferred("add_child", bullet)


func _on_redraw_targets_timeout():
	$Area2D.monitoring = false
	$Area2D.monitoring = true


func _on_area_2d_area_entered(area):
	asteroidsInRange.append(area.get_parent())
	if readyForShot:
		readyForShot = false
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


func _on_boss_shot_timer_timeout():
	if phase == 1 or phase == 3 and bossPhase > 1:
		bossShot()


func _on_hpbar_changed():
	maxHp = $hp/hpbar.max_value
