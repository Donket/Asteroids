extends CharacterBody2D


var speed = 0: set = changeSpeed
var acceleration = 0: set = WagonWheel
var direction = 45
var seekRadius = 500
var turnSpeed = 15

var throwPillowed = false

var immune = true
var parasiteStart = false
var dead = false

@onready var attributes = $attributes
@onready var id = randi()
var ship
var slot
var asteroidName

func WagonWheel(accel):
	acceleration = accel
	var n = Global.numOfStars("Wagon Wheel")
	if acceleration >= 100 and n > 0 and Global.battleScene.rules.burnoutAmount >= 5:
		Global.battleScene.rules.burnoutAmount -= 5
		attributes.bounces += 5
		acceleration = attributes.baseAcceleration
		speed = attributes.baseSpeed
		seekRadius *= 2
		turnSpeed *= 2

func _ready():
	speed = attributes.baseSpeed
	acceleration = attributes.baseAcceleration
	for i in range(Global.numOfStars("Throw Pillow")):
		if Global.randChance(5):
			throwPillowed = true
			position.x = randi_range(-529,529)
			position.y = randi_range(-419,79)
			speed = 0
			await get_tree().create_timer(5).timeout
			speed = attributes.baseSpeed
			attributes.bounces *= 2
			attributes.damage *= 2
			
			
	get_parent().onSpawn($".")
	if attributes.has_method("onSpawn"):
		attributes.onSpawn()
	if throwPillowed:
		speed = 0
		acceleration = 0

func changeSpeed(newSpeed):
	if "Gilded" in Global.asteroidsDeck[slot] and newSpeed > speed and speed != 0:
		var n = Global.numOfStars("Gilded Essence")
		if n > 0:
			Global.battleScene.money += 5 * n
	speed = newSpeed

func _physics_process(delta):
	if dead or throwPillowed:
		return
	if ship:
		seekShip(delta)
	if speed < 0:
		speed = 0
	velocity = Vector2(speed*2*cos(-deg_to_rad(direction)), speed*2*sin(-deg_to_rad(direction)))
	speed += acceleration*delta
	edgeCheck()
	var numOfSnowballs = Global.numOfStars("Snowball")
	$".".scale += Vector2(0.005*acceleration*delta*numOfSnowballs, 0.005*acceleration*delta*numOfSnowballs)
	move_and_slide()


func edgeCheck():
	if immune:
		return
	
	var hit_edge = false
	
	if abs(position.x) >= 530:
		hit_edge = true
	elif position.y < -420 or position.y > 80:
		hit_edge = true
	
	if hit_edge:
		immune = true
		if attributes.bounces == 0:
			if attributes.has_method("onCrash"):
				attributes.onCrash()
			
			get_parent().onCrash(self)
			var n = Global.numOfStars("Death Rattle")
			if n > 0:
				for i in range(n):
					attributes.onBounce()
			die()

		else:
			if attributes.has_method("onBounce"):
				attributes.onBounce()
			$AudioStreamPlayer.stream = load("res://MUSIC/sfx/bounce"+str(randi_range(1,4))+".wav")
			$AudioStreamPlayer.playing = true
			get_parent().onBounce(self)
			attributes.bounces -= 1
			
			if abs(position.x) >= 530:
				direction = 540 - direction % 360
				position.x = clamp(position.x, -529, 529)
			if position.y < -420 or position.y > 80:
				direction = 360 - direction
				position.y = clamp(position.y, -419, 79)
			
			$Timer.start(0.05)

func _on_timer_timeout():
	immune = false

func spawned():
	parasite()

func parasite():
	parasiteStart = true

func _on_area_2d_body_entered(body):
	if parasiteStart or dead:
		return
	elif body == ship:
		if attributes.has_method("onHit"):
			attributes.onHit()
		if attributes.has_method("onCrash"):
			attributes.onCrash()
		get_parent().onHit($".")
		if attributes.has_method("onBounce"):
			var n = Global.numOfStars("Death Rattle")
			if n > 0:
				for i in range(n):
					attributes.onBounce()
		die()
	else:
		if attributes.has_method("onShot"):
			attributes.onShot()
		#if body.name != "saw":
			#body.queue_free()
		get_parent().onShot($".")
		if Global.hit():
			die()


func die():
	if !dead:
		Global.camShake(5)
		dead = true
		velocity = Vector2(0,0)
		$Sprite2D.visible=false
		$GPUParticles2D.emitting=true
		$AudioStreamPlayer.stream = load("res://MUSIC/sfx/hit"+str(randi_range(1,4))+".wav")
		$AudioStreamPlayer.playing = true
		var timer = Timer.new()
		add_child(timer)
		timer.start()
		if Global.numOfStars("Recursive") > 0 and self == Global.battleScene.asteroids[0] and !Global.battleScene.ended:
			Global.battleScene.spawn(attributes,Global.asteroidsDeck[slot])
			var asteroid = Global.battleScene.asteroids[Global.battleScene.asteroids.size()-1]
			Global.battleScene.asteroids[Global.battleScene.asteroids.size()-1]=Global.battleScene.asteroids[0]
			Global.battleScene.asteroids[0]=asteroid
			await timer.timeout
			Global.battleScene.asteroids[0].get_node("attributes").damage = attributes.damage
			Global.battleScene.asteroids[0].get_node("attributes").baseSpeed = speed
		else:
			await timer.timeout
		queue_free()


func _on_parasite_timer_timeout():
	parasiteStart = false


func seekShip(delta):
	var toPlayer = ship.global_position - global_position
	var distance = toPlayer.length()
	if distance > seekRadius:
		return
	var n = Global.numOfStars("Blind Stick")
	if n == 0:
		var targetAngle = rad_to_deg(atan2(-toPlayer.y, toPlayer.x))
		var angleDiff = wrapf(targetAngle - direction, -180.0, 180.0)
		var maxTurn = turnSpeed * delta
		direction += clamp(angleDiff, -maxTurn, maxTurn)
		direction = int(direction)
		return
	if distance < seekRadius:
		var awayAngle = rad_to_deg(atan2(toPlayer.y, -toPlayer.x))
		var angleDiff = wrapf(awayAngle - direction, -180.0, 180.0)
		var strengthMultiplier = 1.0 + (0.5 * n)
		var maxTurn = turnSpeed * strengthMultiplier * delta
		direction += clamp(angleDiff, -maxTurn, maxTurn)
		direction = int(direction)
