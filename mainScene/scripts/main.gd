extends Node2D

var deck = Global.asteroidsDeck
var deckTimes = [3, 3, 3, 3, 3, 3]
var money = 0: set = changeMoney
var ended = false
var asteroids = []
var paused = false

var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")


@onready var launchers = $CanvasLayer/launchers/GridContainer
@onready var ship = $ship
@onready var rules = $rules
@onready var cam = $cam

var pending_updates = 0
var is_processing = false


#Cam shake bs

var shakeTimer = 0.0
var shakeIntensity = 0.0
var originalCamPos = Vector2.ZERO



func camShake(intensity):
	shakeIntensity = intensity
	shakeTimer = 0.15
	originalCamPos = cam.position


func changeMoney(newMoney):
	Global.money = newMoney
	money = newMoney + Global.numOfStars("Golden Tooth") * 3
	$CanvasLayer/moneyLabel.text = str(money)
	pending_updates += 1
	if is_processing:
		return
	is_processing = true
	while pending_updates > 0:
		await debtCollecter()
		pending_updates -= 1
	is_processing = false
	var n = Global.numOfStars("Astral Essence")
	if n > 0:
		for asteroid in asteroids:
			if asteroid.is_instance_valid() and "Astral" in Global.asteroidsDeck[asteroid.slot]:
				asteroid.attributes.damage += 5

func debtCollecter():
	for i in 1 + Global.numOfStars("Golden Tooth"):
		for j in Global.numOfStars("Debt Collector"):
			if Global.randChance(10) and deck[2] != null and !ended:
				launch(2, false)
				await get_tree().create_timer(0.1).timeout


func onBounce(asteroid):
	for child in rules.get_children():
		if child.has_method("onBounce"):
			child.onBounce(asteroid)
	if rules.has_method("onBounce"):
		rules.onBounce(asteroid)


func onCrash(asteroid):
	var n = Global.numOfStars("Death Rattle")
	for child in rules.get_children():
		if child.has_method("onCrash"):
			child.onCrash(asteroid)
		if child.has_method("onBounce") and n > 0:
			for i in range(n):
				child.onBounce()
	if rules.has_method("onCrash"):
		rules.onCrash(asteroid)
		if n > 0:
			for i in range(n):
				rules.onCrash()

func onSpawn(asteroid):
	$spawnPlayer.playing = true
	for child in rules.get_children():
		if child.has_method("onSpawn"):
			child.onSpawn(asteroid)
	if rules.has_method("onSpawn"):
		rules.onSpawn(asteroid)
	

func onHit(asteroid):
	for child in rules.get_children():
		if child.has_method("onHit"):
			child.onHit(asteroid)
	if rules.has_method("onHit"):
		rules.onHit(asteroid)

func onShot(asteroid):
	for child in rules.get_children():
		if child.has_method("onShot"):
			child.onShot(asteroid)
	if rules.has_method("onShot"):
		rules.onShot(asteroid)


func _on_breach_timer_timeout():
	if rules.breachAmount > 0:
		rules.hp -= ceil(rules.hp*0.02*rules.breachAmount)
		Global.addToLog("Breach",ceil(rules.hp*0.02*rules.breachAmount))
		
func _on_parasite_timer_timeout():
	if rules.parasiteAmount > 0 and randi_range(0,100) < 5*rules.parasiteAmount and deck.size() > 0:
		var scene = load("res://asteroids/baseAsteroid/asteroid.tscn").instantiate()
		var sceneAttributes = scene.get_node("attributes")
		sceneAttributes.set_script(load("res://asteroids/" + deck[0] + ".gd"))
		scene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + deck[0] + ".png")
		scene.direction = int(-ship.rotation + randi_range(-120,120))
		scene.position = ship.position
		scene.ship = ship
		scene.slot = 0
		scene.parasite()
		sceneAttributes.launcher = launchers.get_child(0)
		sceneAttributes.main = self
		asteroids.append(scene)
		add_child(scene)
		ship.get_node("parasiteParticles").emitting = true

func _on_burnout_timer_timeout():
	if rules.burnoutAmount > 0:
		var amt = rules.burnoutAmount
		rules.hp -= 3*amt
		Global.addToLog("Burnout",3*amt)
		ship.moveSpeed /= max(1,amt*0.5)
		ship.rotationSpeed /= max(1,amt*0.5)
		ship.shootingDisabled = true
		await get_tree().create_timer(min(amt*0.1,4)).timeout
		ship.moveSpeed *= max(1,amt*0.5)
		ship.rotationSpeed *= max(1,amt*0.5)
		ship.shootingDisabled = false

func snowman():
	if Global.numOfStars("Snowman") > 0:
		if Global.numOfStars("Snowball") >= 4:
			return pow(0.35,Global.numOfStars("Snowman"))
	return 1

func _ready():
	if Global.wins + 1*pow(2,Global.numOfStars("Steak")) >= Global.maxWins:
		$music1.stream = load("res://MUSIC/leading_the_charge_loopable.wav")
		$music1.playing = true
	Global.battleScene = self
	var permStatIndices = []
	for i in range(deck.size()):
		permStatIndices.append(i)
	var snowmanMulti = snowman()
	for i in deck.size():
		if deck[i]:
			$timers.get_child(i).start(deckTimes[i]*snowmanMulti)
			launchers.get_child(i).max_time = deckTimes[i]
			launchers.get_child(i).index = permStatIndices[i]
			launchers.get_child(i).texture = load("res://ART/asteroidArts/" + deck[i] + ".png")
			launchers.get_child(i).empty = false
			launchers.get_child(i).item = deck[i]
	for star in Global.starsDeck:
		var scene = load("res://mainScene/scenes/baseStar.tscn").instantiate()
		scene.set_script(load("res://stars/" + star + ".gd"))
		if "main" in scene:
			scene.main = self
		rules.add_child(scene)
	ship.attributes = rules
	money = Global.money
	Global.logData = {}
	Global.block = 0
	$CanvasLayer/HSlider.value=Global.timeScale
	refreshStatLabels()
	cam.make_current()


func refreshStatLabels():
	var labels = $CanvasLayer/statLabels
	if ended: return
	for i in range(0,6):
		var relevantAsteroids = []
		for asteroid in asteroids:
			if is_instance_valid(asteroid) and asteroid.slot == i:
				relevantAsteroids.append(asteroid)
		
		var averageDmg = 0
		for asteroid in relevantAsteroids:
			averageDmg += asteroid.attributes.damage
		if relevantAsteroids.size() > 0:
			averageDmg /= relevantAsteroids.size()
			
		var averageSpd = 0
		for asteroid in relevantAsteroids:
			averageSpd += asteroid.speed
		if relevantAsteroids.size() > 0:
			averageSpd /= relevantAsteroids.size()
		
		var label = labels.get_child(i)
		label.text = "[center]ADMG: " + str(round(averageDmg)) + "
ASPD: " + str(round(averageSpd)) + "
PDMG: " + str(round(Global.asteroidPermStats[i][0])) + "
PSPD: " + str(round(Global.asteroidPermStats[i][1])) + "
Count: " + str(round(relevantAsteroids.size()))
	await get_tree().create_timer(0.5, true, false, true).timeout
	refreshStatLabels()


func defeat():
	if !ended:
		for child in $timers.get_children():
			child.stop()
		$rulesTimer.stop()
		ended = true
		for child in asteroids:
			if child != null:
				child.die()
		$CanvasLayer/defeatLabel.visible = true
		Global.health -= 2 * pow(2,Global.numOfStars("Steak"))
		money += round(300 * pow(1.1,Global.turn))
		$CanvasLayer/winsLabel.text = "[right][img]res://ART/icons/winsIcon.png[/img]"+str(Global.wins)+"/"+str(Global.maxWins)+"[right][img]res://ART/icons/healthIcon.png[/img]"+str(Global.health)+"/10"
		$CanvasLayer/winsLabel.visible = true
		if ship.phase == 3:
			return
		var tween = get_tree().create_tween()
		tween.set_speed_scale(1.0/Engine.time_scale)
		tween.parallel().tween_property($music1, "volume_db", -30, 1)
		tween.parallel().tween_property($music2, "volume_db", 0, 1)
		$CanvasLayer/HSlider.value = 1
		$CanvasLayer/HSlider.editable = false
		Global.battleTutorialComplete = true
	
	
func victory():
	if !ended:
		for child in $timers.get_children():
			child.stop()
		$rulesTimer.stop()
		ended = true
		for child in asteroids:
			if child != null:
				child.die()
		$CanvasLayer/victoryLabel.visible = true
		Global.wins += 1 * pow(2,Global.numOfStars("Steak"))
		money += round(300 * pow(1.1,Global.turn))
		$CanvasLayer/winsLabel.text = "[right][img]res://ART/icons/winsIcon.png[/img]"+str(Global.wins)+"/"+str(Global.maxWins)+"[right][img]res://ART/icons/healthIcon.png[/img]"+str(Global.health)+"/10"
		$CanvasLayer/winsLabel.visible = true
		if ship.phase == 3:
			return
		var tween = get_tree().create_tween()
		tween.set_speed_scale(1.0/Engine.time_scale)
		tween.parallel().tween_property($music1, "volume_db", -30, 1)
		tween.parallel().tween_property($music2, "volume_db", 0, 1)
		$CanvasLayer/HSlider.value = 1
		$CanvasLayer/HSlider.editable = false
		Global.battleTutorialComplete = true
		


func _process(delta):
	if !ended:
		for i in range(deck.size()):
			if deck[i]:
				launchers.get_child(i).time = $timers.get_child(i).time_left
	if shakeTimer > 0:
		shakeTimer -= delta
		var offset = Vector2(randf_range(-shakeIntensity, shakeIntensity), randf_range(-shakeIntensity, shakeIntensity))
		cam.position = originalCamPos + offset
	elif cam:
		cam.position = originalCamPos



func timeout(index):
	launch(index, true)
	
func launch(index, atEdge):
	if index >= deck.size() or ended or !deck[index]:
		return
	var scene = load("res://asteroids/baseAsteroid/asteroid.tscn").instantiate()
	scene.get_node("attributes").set_script(load("res://asteroids/" + deck[index] + ".gd"))
	scene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + deck[index] + ".png")
	scene.slot = index
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
	var sceneAttributes = scene.get_node("attributes")
	
	sceneAttributes.launcher = launchers.get_child(index)
	sceneAttributes.main = self
	sceneAttributes.baseSpeed += Global.asteroidPermStats[launchers.get_child(index).index][0]
	sceneAttributes.damage += Global.asteroidPermStats[launchers.get_child(index).index][1]
	scene.ship = ship
	var shotguns = Global.numOfStars("Shotgun")
	if shotguns >= 1:
		var count = 1
		for i in range(shotguns):
			if Global.randChance(5):
				count += 2
			elif Global.randChance(20):
				count += 1
		
		for i in range(count):
			var shotgunScene = load("res://asteroids/baseAsteroid/asteroid.tscn").instantiate()
			var shotsceneAttributes = shotgunScene.get_node("attributes")
			shotsceneAttributes.set_script(load("res://asteroids/" + deck[index] + ".gd"))
			shotgunScene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + deck[index] + ".png")
			shotsceneAttributes.launcher = launchers.get_child(index)
			shotsceneAttributes.main = self
			shotsceneAttributes.baseSpeed += Global.asteroidPermStats[launchers.get_child(index).index][0]
			shotsceneAttributes.damage += Global.asteroidPermStats[launchers.get_child(index).index][1]
			shotgunScene.ship = ship
			shotgunScene.direction = dir + (i-count/2)*30
			shotgunScene.position = scene.position
			shotgunScene.slot = index
			asteroids.append(shotgunScene)
			add_child(shotgunScene)
	
		
	else:
		asteroids.append(scene)
		add_child(scene)


func _on_button_pressed():
	if Global.wins >= Global.maxWins or Global.health <= 0:
		get_tree().change_scene_to_file("res://mainScene/scenes/end.tscn")
	else:
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
		var sceneAttributes = scene.get_node("attributes")
		var asteroidAttributes = asteroid
		sceneAttributes.set_script(load("res://asteroids/" + spawned + ".gd"))
		scene.get_node("Sprite2D").texture = load("res://ART/asteroidArts/" + spawned + ".png")
		scene.direction = int(-asteroid.get_parent().direction + randi_range(-120,120))
		scene.global_position = asteroid.global_position
		sceneAttributes.launcher = launchers.get_child(asteroidAttributes.launcher.index)
		sceneAttributes.main = self
		scene.ship = ship
		scene.slot = asteroid.get_parent().slot
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
	if value <= 0:
		get_tree().paused = true
	else:
		get_tree().paused = false
		Engine.time_scale = value
	if $ship.phase == 3 or ended:
		return
	if value <= 0.05 and !paused:
		enterPauseState(value)
	elif value > 0.05 and paused:
		exitPauseState(value)
	Global.timeScale = value


func enterPauseState(value):
	paused = true
	var tween = get_tree().create_tween()
	tween.set_speed_scale(1.0 / value)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.parallel().tween_property($music1, "volume_db", -30, 1)
	tween.parallel().tween_property($music2, "volume_db", 0, 1)


func exitPauseState(value):
	paused = false
	var tween = get_tree().create_tween()
	tween.set_speed_scale(1.0 / value)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.parallel().tween_property($music1, "volume_db", 0, 1)
	tween.parallel().tween_property($music2, "volume_db", -30, 1)


func _on_h_slider_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_h_slider_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_rules_status_effect_changed():
	if !rules:
		return
	if rules.blockAmount > 0:
		$CanvasLayer/VBoxContainer/blockLabel.visible = true
		$CanvasLayer/VBoxContainer/blockLabel.text = "[img]ART/icons/blockIcon.png[/img] " + str($rules.blockAmount)
	elif rules.blockAmount <= 0:
		$CanvasLayer/VBoxContainer/blockLabel.visible = false
	if rules.breachAmount > 0:
		$CanvasLayer/VBoxContainer/breachLabel.visible = true
		$CanvasLayer/VBoxContainer/breachLabel.text = "[img]ART/icons/breachIcon.png[/img] " + str($rules.breachAmount)
	elif rules.breachAmount <= 0:
		$CanvasLayer/VBoxContainer/breachLabel.visible = false
	if rules.parasiteAmount > 0:
		$CanvasLayer/VBoxContainer/parasiteLabel.visible = true
		$CanvasLayer/VBoxContainer/parasiteLabel.text = "[img]ART/icons/parasiteIcon.png[/img] " + str($rules.parasiteAmount)
	elif rules.parasiteAmount <= 0:
		$CanvasLayer/VBoxContainer/parasiteLabel.visible = false
	if rules.burnoutAmount > 0:
		$CanvasLayer/VBoxContainer/burnoutLabel.visible = true
		$CanvasLayer/VBoxContainer/burnoutLabel.text = "[img]ART/icons/burnoutIcon.png[/img] " + str($rules.burnoutAmount)
	elif rules.burnoutAmount <= 0:
		$CanvasLayer/VBoxContainer/burnoutLabel.visible = false
	var n = Global.numOfStars("Boot")
	for asteroid in asteroids:
		if is_instance_valid(asteroid):
			asteroid.acceleration += 3 * n
	n = Global.numOfStars("Backpack")
	if Global.randChance(30):
		money += 5 * n


func _on_settings_button_pressed():
	$CanvasLayer/HSlider.value = 0
	$CanvasLayer/Settings.visible = true



func _on_tutorial_button_pressed():
	$CanvasLayer/HSlider.value = 0
	$CanvasLayer/Tutorial.visible = true


func _on_settings_button_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_settings_button_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_tutorial_button_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_tutorial_button_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))

#timer visible, status effects visible, stats visible, time scale visible

func tutorialForce(timerv, statuseffectsv, statsv, timescalev):
	$CanvasLayer/timerLabel.visible = timerv
	$CanvasLayer/VBoxContainer.visible = statuseffectsv
	$CanvasLayer/statLabels.visible = statsv
	$CanvasLayer/HSlider.visible = timescalev
