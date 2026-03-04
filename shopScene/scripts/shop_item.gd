extends Control

@export var type: Type
enum Type { ASTEROID, STAR }

var cost: int = 0
var item: String = "": set = change
var currentBaseRarity: int = 0

@onready var shop = get_parent().get_parent()
@onready var inv = get_parent().get_parent().get_node("shopInvUI")
@onready var hoverSfx = shop.get_node("hover")
@onready var clickSfx = shop.get_node("click")

var itemsToDesc


func change(newItem: String):
	if newItem.is_empty():
		$Node2D.visible = false
		$Control.visible = false
		$RichTextLabel.visible = false
	else:
		$Node2D.visible = true
		$Control.visible = true
		$RichTextLabel.visible = true
		
	item = newItem

func randomizeItem():
	var items
	var dataArr
	if type == Type.ASTEROID:
		items = Global.itemsToData.keys()
		dataArr = Global.itemsToData
	else:
		items = Global.starsToData.keys()
		dataArr = Global.starsToData
	var roll = randf()
	var chosen_rarity = currentBaseRarity
	
	if roll < 0.5:
		chosen_rarity = currentBaseRarity
	elif roll < 0.9:
		if currentBaseRarity > 0:
			chosen_rarity = randi_range(0, currentBaseRarity - 1)
		else:
			chosen_rarity = currentBaseRarity
	else:
		var max_rarity = 0
		for data in Global.itemsToData.values():
			max_rarity = max(max_rarity, data[1])
			
		if currentBaseRarity < max_rarity:
			chosen_rarity = currentBaseRarity + 1
		else:
			chosen_rarity = currentBaseRarity
	
	var possible_items = []
	for i in items:
		if dataArr[i][1] == chosen_rarity:
			possible_items.append(i)
	
	if possible_items.is_empty():
		item = "" 
		cost = 0
		return
	
	item = possible_items[randi_range(0, possible_items.size() - 1)]
	if type == Type.STAR:
		cost = dataArr[item][0] * pow(pow(0.98,Global.starsDeck.size()),Global.numOfStars("Friendly Customer"))
	else:
		cost = dataArr[item][0]
		
	cost = round(cost*pow(0.8, Global.numOfStars("Coupon Book")))
	
	updateData()

func updateData():
	$Control/RichTextLabel.text = "[center]" + item
	if type == Type.ASTEROID:
		$Control/RichTextLabel2.text = Global.getDesc(item,1)
		$RichTextLabel.text = "[center]" + str(cost)
		$Node2D.texture = load("res://ART/asteroidArts/" + item + ".png")
		$Control/spdLabel.text = "[center]"+str(Global.itemsToData[item][2])
		$Control/dmgLabel.text = "[center]"+str(Global.itemsToData[item][3])
	else:
		$Control/RichTextLabel2.text = itemsToDesc[item]
		$RichTextLabel.text = "[center]" + str(cost)
		$Node2D.texture = load("res://ART/starArts/" + item + ".png")
	
	initTooltips()
	var tween = get_tree().create_tween()
	tween.tween_property($Node2D, "position", Vector2(0,-10), 0.02)
	tween.tween_property($Node2D, "position", Vector2(0,0), 0.02)
	await tween.finished


func _ready():
	itemsToDesc = Global.itemsToDesc
	currentBaseRarity = min(3,floor(Global.turn/2))
	randomizeItem()
	if type == Type.ASTEROID:
		$RichTextLabel.position = Vector2(-168,121)
	elif type == Type.STAR:
		$RichTextLabel.position = Vector2(-168,130)
		$Control/Sprite2D.texture = load("res://ART/uiArts/starShopPanel.png")
		$Node2D.scale = Vector2(4,4)
		$Control/dmgLabel.visible = false
		$Control/spdLabel.visible = false
		$Control/RichTextLabel5.visible = false
		$Control/RichTextLabel6.visible = false

func _on_control_2_mouse_entered():
	hoverSfx.playing=true
	$AnimationPlayer.play("open")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



func _on_control_2_mouse_exited():
	$AnimationPlayer.play("close")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_control_2_pressed():
	clickSfx.playing=true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	buy(true)

func buy(spending):
	cost = floor(cost)
	if item.is_empty() or shop.money < cost:
		return
	
	elif type == Type.ASTEROID and null in Global.asteroidsDeck:
		for i in range(Global.asteroidsDeck.size()):
			if Global.asteroidsDeck[i] == null:
				Global.asteroidsDeck[i] = item
				Global.asteroidPermStats[i] = [0,0]
				item = ""
				$CPUParticles2D.emitting = true
				if spending:
					shop.money -= cost
				break
				
	elif type == Type.ASTEROID and item in Global.asteroidsDeck:
		for i in range(Global.asteroidsDeck.size()):
			if Global.asteroidsDeck[i] == item:
				Global.asteroidsDeck[i] = item
				Global.asteroidExps[i] += 1
				item = ""
				$CPUParticles2D.emitting = true
				if spending:
					shop.money -= cost
				break
	
	elif type == Type.STAR and Global.starsDeck.size() < 6:
		Global.starsDeck.append(item)
	
		if item == "Coupon Book":
			shop.rollPrice *= 1.2 
		
		item = ""
		$CPUParticles2D.emitting = true
		if spending:
			shop.money -= cost
		
	for j in Global.numOfStars("Light Fingers"):
		for i in shop.items:
			if i.type == 1 and i != self:
				if Global.randChance(5):
					i.buy(false)
	inv.refresh()


func initTooltips():
	var container = $Control/GridContainer
	for tt in container.get_children():
		tt.free()
	container.position.y = -50
	var tooltips = ["res://ART/icons/parasiteIcon.png", "res://ART/icons/burnoutIcon.png", "res://ART/icons/moneyIcon.png", "res://ART/icons/breachIcon.png", "res://ART/icons/blockIcon.png", "res://ART/icons/bounceIcon.png", "res://ART/icons/spawnIcon.png"]
	if position.x == -710:
		container.position.x = 290
	for tt in tooltips:
		if tt in $Control/RichTextLabel2.text:
			var scene = load("res://shopScene/scenes/tooltip.tscn").instantiate()
			scene.type = tt
			container.add_child(scene)
	container.position.y -= 90*(container.get_child_count()-1)

