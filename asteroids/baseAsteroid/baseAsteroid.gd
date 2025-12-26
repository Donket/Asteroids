extends CharacterBody2D


var speed = 0
var acceleration = 0
var direction = 45
var seekRadius = 300
var turnSpeed = 10


var immune = true
var parasiteStart = false
var dead = false

@onready var attributes = $attributes
var ship
var slot 


func _ready():
	speed = attributes.baseSpeed
	acceleration = attributes.baseAcceleration
	get_parent().onSpawn($".")

func _physics_process(delta):
	if dead:
		return
	if ship:
		seekShip(delta)
	if speed < 0:
		speed = 0
	velocity = Vector2(speed*cos(-deg_to_rad(direction)), speed*sin(-deg_to_rad(direction)))
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
			die()

		else:
			if attributes.has_method("onBounce"):
				attributes.onBounce()
			get_parent().onBounce(self)
			attributes.bounces -= 1
			
			if abs(position.x) >= 530:
				direction = 540 - direction % 360
				position.x = clamp(position.x, -529, 529)
			if position.y < -420 or position.y > 80:
				direction = 360 - direction
				position.y = clamp(position.y, -419, 79)
			print(position)
			
			$Timer.start(0.05)

func _on_timer_timeout():
	immune = false

func spawned():
	parasite()

func parasite():
	parasiteStart = true

func _on_area_2d_body_entered(body):
	if parasiteStart:
		return
	if body == ship:
		if attributes.has_method("onHit"):
			attributes.onHit()
		if attributes.has_method("onCrash"):
			attributes.onCrash()
		
		get_parent().onHit($".")
	else:
		if attributes.has_method("onShot"):
			attributes.onShot()
		get_parent().onShot($".")
	die()


func die():
	if !dead:
		dead = true
		velocity = Vector2(0,0)
		$Sprite2D.visible=false
		$GPUParticles2D.emitting=true
		var timer = Timer.new()
		add_child(timer)
		timer.start()
		await timer.timeout
		queue_free()


func _on_parasite_timer_timeout():
	parasiteStart = false


func seekShip(delta):
	var toPlayer = ship.global_position - global_position
	var distance = toPlayer.length()
	if distance > seekRadius:
		return
	var targetAngle = rad_to_deg(atan2(-toPlayer.y, toPlayer.x))
	var angleDiff = wrapf(targetAngle - direction, -180.0, 180.0)
	var maxTurn = turnSpeed * delta
	direction += clamp(angleDiff, -maxTurn, maxTurn)
	direction = int(direction)
