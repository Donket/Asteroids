extends Control

@export var type: Type
enum Type { ASTEROID, STAR }

var cost: int = 0
var item: String = "": set = change
var currentBaseRarity: int = 0

@onready var shop = get_parent().get_parent()

var itemsToDesc = {

	# Iron Family
	"Iron Husk": 
"Has: 1 [img]res://ART/icons/bounceIcon.png[/img]",

	"Iron Rock": 
"On Crash: [img]res://ART/icons/spawnIcon.png[/img] Iron Husk",

	"Iron Gem": 
"On Hit: Apply 1 [img]res://ART/icons/breachIcon.png[/img]",

	"Iron Relic": 
"On Bounce: Gain Acceleration

Has: 1 [img]res://ART/icons/bounceIcon.png[/img]",

	"Iron Meteor": 
"On Hit: [img]res://ART/icons/spawnIcon.png[/img] 2 random Irons",


	# Ancient Family
	"Ancient Husk": 
"On Hit: Apply [img]res://ART/icons/burnoutIcon.png[/img] (25% chance)",

	"Ancient Rock": 
"On Hit: Apply 1 [img]res://ART/icons/parasiteIcon.png[/img]",

	"Ancient Gem": 
"On Hit: Activates [img]res://ART/icons/breachIcon.png[/img]",

	"Ancient Relic": 
"On Crash: [img]res://ART/icons/spawnIcon.png[/img] random Relic (can't spawn Ancient Relic)",

	"Ancient Meteor": 
"On Hit: [img]res://ART/icons/spawnIcon.png[/img] 3 Ancients",


	# Cursed Family
	"Cursed Husk": 
"On Hit: 50% chance + 3 [img]res://ART/icons/moneyIcon.png[/img]
Otherwise - 2 [img]res://ART/icons/moneyIcon.png[/img]",

	"Cursed Rock": 
"On Crash: 50% chance [img]res://ART/icons/spawnIcon.png[/img] a random Rock, 50% chance gain +5 permanent damage",

	"Cursed Gem": 
"On Hit: 50% chance to apply 2 [img]res://ART/icons/breachIcon.png[/img], 50% chance to apply 1 [img]res://ART/icons/burnoutIcon.png[/img]",

	"Cursed Relic": 
"Has: 1 [img]res://ART/icons/bounceIcon.png[/img]
On Bounce: + 1 [img]res://ART/icons/bounceIcon.png[/img] - 20 damage",

	"Cursed Meteor": 
"On Hit: [img]res://ART/icons/spawnIcon.png[/img] 4 Cursed. Each has a 50% chance to be destroyed immediately",

	# Gilded Family
	"Gilded Husk":
"On Hit: Gain +2 [img]res://ART/icons/moneyIcon.png[/img]",

	"Gilded Rock":
"Has: 1 [img]res://ART/icons/bounceIcon.png[/img]
On Bounce: Spend 3 [img]res://ART/icons/moneyIcon.png[/img] to gain + 1 [img]res://ART/icons/bounceIcon.png[/img].",

	"Gilded Gem":
"On Crash: If you have 100+ [img]res://ART/icons/moneyIcon.png[/img], convert 10 [img]res://ART/icons/moneyIcon.png[/img] into +4 permanent damage and +4 permanent speed",

	"Gilded Relic":
"On Bounce: Gain +5 [img]res://ART/icons/moneyIcon.png[/img]  
Has: 2 [img]res://ART/icons/bounceIcon.png[/img]",

	"Gilded Meteor":
"On Hit: [img]res://ART/icons/moneyIcon.png[/img] +100  
Lose 1 random asteroid",


	# Stars
	
	"Dice": 
"Random chances +10% (cannot stack above 90%)",
	"Boot": 
"Asteroid Acceleration +30",
	"Backpack": 
"Asteroids gain 1% speed for each Star you own",
	"Goop": 
"Asteroids in Slot 1 gain +2 [img]res://ART/icons/bounceIcon.png[/img]. However, On Bounce they lose 20 speed",
	"Hanger":
"Upon spawning an asteroid, 20% (cannot be increased) chance to destroy it and gain +4 [img]res://ART/icons/moneyIcon.png[/img]",
	"Hourglass":
"Timer is 10% longer.",
	"Pipe": 
"On hit effects have a 20% chance of triggering twice (Does not affect star abilities).",
	"Spider": 
"All asteroid stats +20%. - 10 [img]res://ART/icons/moneyIcon.png[/img] when destroyed.",
	"Steak": 
"Each win gives double victories, and each loss takes double lives.",
	"Steering Wheel": 
"Asteroids steer towards the ship more directly. This effect increases with asteroid acceleration.",
	"Speedometer": 
"Gain 1 [img]res://ART/icons/moneyIcon.png[/img] per second, multiplied by 10% of average asteroid speed.",
	"Light Fingers": 
"On purchasing a shop item, 5% chance to also obtain all stars in shop.",
	"Friendly Customer":
"Each star you obtain reduces the cost of future stars by 2%",
	"Snowball":
"As asteroids accelerate, they gain size.",
	"Lethal":
"If you will die next loss, all asteroid stats +20%",
	"Golden Tooth":
"Whenever you gain [img]res://ART/icons/moneyIcon.png[/img], gain +1 extra",
	"Loose Change":
"All asteroids 30% chance to drop +2 [img]res://ART/icons/moneyIcon.png[/img] On Crash",
	"Coupon Book":
"Future items cost 20% less, but rerolls cost 20% more",
	"Payday":
"At the start of each round, + 5 [img]res://ART/icons/moneyIcon.png[/img]",
	"Tip Jar":
"Each On Hit effect has a 10% chance to grant +1 [img]res://ART/icons/moneyIcon.png[/img]",
	"Debt Collector":
"Every time you gain money in battle, 10% (cannot be increased) chance to spawn a copy of the asteroid in Slot 3 on top of the ship.",
	"Piggy Bank":
"Unspent [img]res://ART/icons/moneyIcon.png[/img] grants +1% asteroid stats per 200 money",
	"Minivan":
"Gain 3 asteroid acceleration for each asteroid on screen.",
	"Binky":
"-20% asteroid speed",
	"Bottle":
"When an asteroid spawns, 10% (cannot be increased) chance to give the asteroid in Slot 4 +2 permanent damage.",
	"Throw Pillow":
"Each asteroid that spawns has a 1% (cannot be increased) chance on spawn to teleport to and remain at a random location",
	"Suicide Bomb":
"On Crash, each asteroid has a 20% chance to deal its damage to the ship.",
	"Shotgun":
"Each time an asteroid is launched, 20% chance to launch an extra and 10% (cannot be increased) chance to launch two extra.",
}


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
	$Control/RichTextLabel2.text = itemsToDesc[item]
	if type == Type.ASTEROID:
		$RichTextLabel.text = "[center]" + str(cost)
		$Node2D.texture = load("res://ART/asteroidArts/" + item + ".png")
		$Control/spdLabel.text = "[center]"+str(Global.itemsToData[item][2])
		$Control/dmgLabel.text = "[center]"+str(Global.itemsToData[item][3])
	else:
		$RichTextLabel.text = "[center]" + str(cost)
		$Node2D.texture = load("res://ART/starArts/" + item + ".png")
	
	var tween = get_tree().create_tween()
	tween.tween_property($Node2D, "position", Vector2(0,-10), 0.02)
	tween.tween_property($Node2D, "position", Vector2(0,0), 0.02)
	await tween.finished


func _ready():
	currentBaseRarity = min(3,floor(Global.turn/2))
	randomizeItem()
	if type == Type.ASTEROID:
		$RichTextLabel.position = Vector2(-168,136)
	elif type == Type.STAR:
		$RichTextLabel.position = Vector2(-268,213)
		$Control/Sprite2D.texture = load("res://ART/uiArts/starShopPanel.png")
		$Control/dmgLabel.visible = false
		$Control/spdLabel.visible = false
		$Control/RichTextLabel5.visible = false
		$Control/RichTextLabel6.visible = false

func _on_control_2_mouse_entered():
	if shop.invOpen != true:
		$AnimationPlayer.play("open")
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



func _on_control_2_mouse_exited():
	if shop.invOpen != true:
		$AnimationPlayer.play("close")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_control_2_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	buy(true)

func buy(spending):
	cost = floor(cost)
	if item.is_empty() or shop.invOpen == true or shop.money < cost:
		return
	
	if type == Type.ASTEROID and null in Global.asteroidsDeck:
		for i in range(Global.asteroidsDeck.size()):
			if Global.asteroidsDeck[i] == null:
				Global.asteroidsDeck[i] = item
				Global.asteroidPermStats[i] = [0,0]
				item = ""
				$CPUParticles2D.emitting = true
				if spending:
					shop.money -= cost
				
				break
	
	elif type == Type.STAR:
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

