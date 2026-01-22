extends Node2D

var deck = Global.asteroidsDeck
var deckTimes = [3, 3, 3, 3, 3, 3]
var money = 0: set = changeMoney
var ended = false
var asteroids = []


@onready var launchers = $CanvasLayer/launchers/GridContainer
@onready var ship = $ship

var pending_updates = 0
var is_processing = false

func changeMoney(newMoney):
	Global.money = newMoney
	money = newMoney + Global.numOfStars("Golden Tooth")
	$CanvasLayer/moneyLabel.text = str(money)
	pending_updates += 1
	if is_processing:
		return
	is_processing = true
	while pending_updates > 0:
		await debtCollecter()
		pending_updates -= 1
	is_processing = false

func debtCollecter():
	for i in 1 + Global.numOfStars("Golden Tooth"):
		for j in Global.numOfStars("Debt Collector"):
			if randf_range(0,1) <= 0.1 and deck[2] != null and !ended:
				launch(2, false)
				await get_tree().create_timer(0.1).timeout


func onBounce(asteroid):
	for child in $rules.get_children():
		if child.has_method("onBounce"):
			child.onBounce(asteroid)
	if $rules.has_method("onBounce"):
		$rules.onBounce(asteroid)
	

func onCrash(asteroid):
	for child in $rules.get_children():
		if child.has_method("onCrash"):
			child.onCrash(asteroid)
	if $rules.has_method("onCrash"):
		$rules.onCrash(asteroid)

func onSpawn(asteroid):
	for child in $rules.get_children():
		if child.has_method("onSpawn"):
			child.onSpawn(asteroid)
	if $rules.has_method("onSpawn"):
		$rules.onSpawn(asteroid)
	

func onHit(asteroid):
	for child in $rules.get_children():
		if child.has_method("onHit"):
			child.onHit(asteroid)
	if $rules.has_method("onHit"):
		$rules.onHit(asteroid)

func onShot(asteroid):
	for child in $rules.get_children():
		if child.has_method("onShot"):
			child.onShot(asteroid)
	if $rules.has_method("onShot"):
		$rules.onShot(asteroid)


func _on_breach_timer_timeout():
	if $rules.breachAmount > 0:
		$rules.hp -= $rules.maxHP*0.01*$rules.breachAmount
		
func _on_parasite_timer_timeout():
	if $rules.parasiteAmount > 0 and randi_range(0,100) < 5*$rules.parasiteAmount and deck.size() > 0:
		var scene = load("res://asteroids/baseAsteroid/asteroid.tscn").instantiate()
		scene.get_node("attributes").set_script(load("res://asteroids/" + deck[0] + ".gd"))
		scene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + deck[0] + ".png")
		scene.direction = int(-ship.rotation + randi_range(-120,120))
		scene.position = ship.position
		scene.parasite()
		scene.get_node("attributes").launcher = launchers.get_child(0)
		scene.get_node("attributes").main = self
		asteroids.append(scene)
		add_child(scene)
		ship.get_node("parasiteParticles").emitting = true

func _on_burnout_timer_timeout():
	if $rules.burnoutAmount > 0:
		var amt = $rules.burnoutAmount
		$rules.hp -= 3*amt
		$ship.moveSpeed /= max(1,amt*0.5)
		$ship.rotationSpeed /= max(1,amt*0.5)
		await get_tree().create_timer(3).timeout
		$ship.moveSpeed *= max(1,amt*0.5)
		$ship.rotationSpeed *= max(1,amt*0.5)


func _ready():
	var permStatIndices = []
	for i in range(deck.size()):
		permStatIndices.append(i)
	for i in deck.size():
		if deck[i]:
			$timers.get_child(i).start(deckTimes[i])
			launchers.get_child(i).max_time = deckTimes[i]
			launchers.get_child(i).index = permStatIndices[i]
			launchers.get_child(i).texture = load("res://ART/asteroidArts/" + deck[i] + ".png")
	for star in Global.starsDeck:
		var scene = load("res://mainScene/scenes/baseStar.tscn").instantiate()
		scene.set_script(load("res://stars/" + star + ".gd"))
		if "main" in scene:
			scene.main = self
		$rules.add_child(scene)
	ship.attributes = $rules
	money = Global.money


func defeat():
	if !ended:
		for child in $timers.get_children():
			child.stop()
		ended = true
		for child in asteroids:
			if child != null:
				child.die()
		$CanvasLayer/defeatLabel.visible = true
		Global.health -= 2 * pow(2,Global.numOfStars("Steak"))
		money += round(300 * pow(1.2,Global.turn))
		$CanvasLayer/winsLabel.text = "[right][img]res://ART/icons/winsIcon.png[/img]"+str(Global.wins)+"/"+str(Global.maxWins)+"[right][img]res://ART/icons/healthIcon.png[/img]"+str(Global.health)+"/10"
		$CanvasLayer/winsLabel.visible = true
	
	
func victory():
	if !ended:
		for child in $timers.get_children():
			child.stop()
		ended = true
		for child in asteroids:
			if child != null:
				child.die()
		$CanvasLayer/victoryLabel.visible = true
		Global.wins += 1 * pow(2,Global.numOfStars("Steak"))
		money += round(300 * pow(1.2,Global.turn))
		$CanvasLayer/winsLabel.text = "[right][img]res://ART/icons/winsIcon.png[/img]"+str(Global.wins)+"/"+str(Global.maxWins)+"[right][img]res://ART/icons/healthIcon.png[/img]"+str(Global.health)+"/10"
		$CanvasLayer/winsLabel.visible = true
		


func _process(delta):
	if !ended:
		for i in range(deck.size()):
			if deck[i]:
				launchers.get_child(i).time = $timers.get_child(i).time_left
	if $rules.breachAmount > 0:
		$CanvasLayer/breachLabel.text = "[img]ART/icons/breachIcon.png[/img] " + str($rules.breachAmount)
	elif $rules.breachAmount <= 0:
		$CanvasLayer/breachLabel.text = ""
	if $rules.parasiteAmount > 0:
		$CanvasLayer/parasiteLabel.text = "[img]ART/icons/parasiteIcon.png[/img] " + str($rules.parasiteAmount)
	elif $rules.parasiteAmount <= 0:
		$CanvasLayer/parasiteLabel.text = ""
	if $rules.burnoutAmount > 0:
		$CanvasLayer/burnoutLabel.text = "[img]ART/icons/burnoutIcon.png[/img] " + str($rules.burnoutAmount)
	elif $rules.burnoutAmount <= 0:
		$CanvasLayer/burnoutLabel.text = ""


func timeout(index):
	launch(index, true)
	
func launch(index, atEdge):
	if index >= deck.size() or ended or !deck[index]:
		return
	var scene = load("res://asteroids/baseAsteroid/asteroid.tscn").instantiate()
	scene.get_node("attributes").set_script(load("res://asteroids/" + deck[index] + ".gd"))
	scene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + deck[index] + ".png")
	var bool1 = false
	if randi_range(0,2)==0:
		bool1 = true
	var bool2 = false
	if randi_range(0,2)==0:
		bool2 = true
	
	if atEdge:
		
		var locations = [bool1, bool2, randi_range(0,6)]
		
		if locations[0]:
			if locations[1]:
				scene.position = Vector2(-850*(3-locations[2])/4, 80)
				scene.direction = 90 + randi_range(-10,10)
			else:
				scene.position = Vector2(-850*(3-locations[2])/4, -420)
				scene.direction = -90 + randi_range(-10,10)
		else:
			if locations[1]:
				scene.position = Vector2(530, 370*(3-locations[2])/5-170)
				scene.direction = 180 + randi_range(-10,10)
			else:
				scene.position = Vector2(-530, 370*(3-locations[2])/5-170)
				scene.direction = 0 + randi_range(-10,10)
				
	else:
		
		scene.position = ship.position
		scene.direction = 0
		scene.speed = 0
		
	var dir = scene.direction
	
	scene.get_node("attributes").launcher = launchers.get_child(index)
	scene.get_node("attributes").main = self
	scene.get_node("attributes").baseSpeed += Global.asteroidPermStats[launchers.get_child(index).index][0]
	scene.get_node("attributes").damage += Global.asteroidPermStats[launchers.get_child(index).index][1]
	scene.ship = ship
	var shotguns = Global.numOfStars("Shotgun")
	if shotguns >= 1:
		var count = 1
		for i in range(shotguns):
			if randf_range(0,1) < 0.1:
				count += 2
			elif Global.randChance(20):
				count += 1
		
		for i in range(count):
			var shotgunScene = load("res://asteroids/baseAsteroid/asteroid.tscn").instantiate()
			shotgunScene.get_node("attributes").set_script(load("res://asteroids/" + deck[index] + ".gd"))
			shotgunScene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + deck[index] + ".png")
			shotgunScene.get_node("attributes").launcher = launchers.get_child(index)
			shotgunScene.get_node("attributes").main = self
			shotgunScene.get_node("attributes").baseSpeed += Global.asteroidPermStats[launchers.get_child(index).index][0]
			shotgunScene.get_node("attributes").damage += Global.asteroidPermStats[launchers.get_child(index).index][1]
			shotgunScene.ship = ship
			shotgunScene.direction = dir + (i-count/2)*30
			shotgunScene.position = scene.position
			asteroids.append(shotgunScene)
			add_child(shotgunScene)
	
		
	else:
		asteroids.append(scene)
		add_child(scene)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://shopScene/scenes/shop.tscn")


func _on_button_mouse_entered():
	$CanvasLayer/victoryLabel/RichTextLabel3.text = "



[center][color=yellow]Click to continue"
	$CanvasLayer/victoryLabel.text = "[center][color=yellow]Victory"



func _on_button_mouse_exited():
	$CanvasLayer/victoryLabel/RichTextLabel3.text = "



[center][color=white]Click to continue"
	$CanvasLayer/victoryLabel.text = "[center][color=white]Victory"






func spawn(asteroid, spawned):
	if !ended:
		var scene = load("res://asteroids/baseAsteroid/asteroid.tscn").instantiate()
		scene.get_node("attributes").set_script(load("res://asteroids/" + spawned + ".gd"))
		scene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + spawned + ".png")
		scene.direction = int(-asteroid.get_parent().direction + randi_range(-120,120))
		scene.global_position = asteroid.global_position
		scene.get_node("attributes").launcher = launchers.get_child(0)
		scene.get_node("attributes").main = self
		scene.spawned()
		asteroids.append(scene)
		call_deferred("add_child",scene)
		return scene




func _on_defeat_button_mouse_entered():
	$CanvasLayer/defeatLabel/RichTextLabel3.text = "



[center][color=yellow]Click to continue"
	$CanvasLayer/defeatLabel.text = "[center][color=yellow]Defeat"


func _on_defeat_button_mouse_exited():
	$CanvasLayer/defeatLabel/RichTextLabel3.text = "



[center][color=yellow]Click to continue"
	$CanvasLayer/defeatLabel.text = "[center][color=yellow]Defeat"



func _on_h_slider_value_changed(value):
	Engine.time_scale = value
