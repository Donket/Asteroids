extends Node2D

#shopdata = {message, message location, shop asteroids, shop stars, inventory visible, sell visible, roll visible, preview visible, tutorial visible, end turn visible, refresh shop}

var inRange
@export var isShop: bool
var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")

var dataShop = [
	
	[
	"Welcome to Asterogue! You are now in the shop. Here, you will buy items with [img width=32 height=32]res://ART/icons/moneyIcon.png[/img]. You can see how much [img width=32 height=32]res://ART/icons/moneyIcon.png[/img] you have in the bottom left.", 
	Vector2(0,0),
	["", "", "", "", ""],
	["", ""],
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	true
	], 
	
	[
	"This is an Asteroid. You can see a description of it by hovering over it, and its price below. This asteroid has one bounce ([img width=32 height=32]res://ART/icons/bounceIcon.png[/img]), meaning when it hits the wall it bounces back instead of being destroyed. Click on it to buy it.", 
	Vector2(0,-50),
	["", "", "Iron Husk", "", ""],
	["", ""],
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	true
	],
	
	[
	"In battle, your owned asteroids will fire every three seconds at an enemy ship, which you must destroy within a time limit. You damage the ship by hitting it with your asteroids, according to their damage.", 
	Vector2(0,-50),
	["", "", "", "", ""],
	["", ""],
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false
	],

	[
	"You can also damage the ship (and do many other things as well) through abilities. Each asteroid type has its own ability, which you can see when hovering. For example, this Gilded Husk drops [img width=32 height=32]res://ART/icons/moneyIcon.png[/img] whenever it hits the ship.", 
	Vector2(0,-50),
	["", "", "Gilded Husk", "", ""],
	["", ""],
	false, 
	false, 
	false, 
	false, 
	false, 
	false, 
	true
	],

	[
	"This is your inventory. Your inventory holds up to 6 asteroids at once. Asteroids that you buy go here automatically, if there is space.", 
	Vector2(0,-50),
	["", "", "", "", ""],
	["", ""],
	true, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false
	],
	

	[
	"You can level up all asteroids in the inventory by combining enough of one kind. Buy all three of these Iron Husks. When you have them in your inventory, click and drag each onto the one you already own. Then, look at its upgraded level 2 ability.", 
	Vector2(0,-50),
	["Iron Husk", "Iron Husk", "Iron Husk", "", ""],
	["", ""],
	true, 
	false, 
	false, 
	false, 
	false, 
	false, 
	true
	],

	[
	"This is a star, the other type of item. Stars provide universal abilities, and cannot be leveled up like asteroids. This star makes you have a chance to gain one [img width=32 height=32]res://ART/icons/blockIcon.png[/img] whenever one of your asteroids bounces off the wall. Click it to buy it.", 
	Vector2(-340,280),
	["", "", "", "", ""],
	["Shield", ""],
	true, 
	false, 
	false, 
	false, 
	false, 
	false, 
	true
	],
	
	[
	"Note that this pairs with the asteroid you bought earlier - the asteroid has a bounce, meaning it activates the star's ability. Making sure the abilities of your items trigger each other is a very powerful and necessary tool! ", 
	Vector2(0,0),
	["", "", "", "", ""],
	["", ""],
	true, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false
	],
	
	[
	"The resource that your new star gives, [img width=32 height=32]res://ART/icons/blockIcon.png[/img], is a status effect. There are a few different status effects, all with different functionalities. If you are ever curious what a status effect does, hover the item that mentions it - there will be a tooltip next to it explaining what it does.", 
	Vector2(0,0),
	["", "", "", "", ""],
	["", ""],
	true, 
	false, 
	false, 
	false, 
	false, 
	false, 
	false
	],
	
	[
	"If you want a new item or star and you already have six, fear not! You can sell your existing asteroids and stars for half value by clicking and dragging them from your inventory to this box, and releasing. Now, try to sell the asteroid you bought earlier.", 
	Vector2(430,300),
	["", "", "", "", ""],
	["", ""],
	true, 
	true, 
	false, 
	false, 
	false, 
	false, 
	false
	],
	
	[
	"This is the roll button. Click it to refresh the shop for new item options, for the price listed in (). Careful not to roll too much, however! This price increases exponentially per roll, and resets to the original price after each battle.", 
	Vector2(-400,300),
	["", "", "", "", ""],
	["", ""],
	true, 
	true, 
	true, 
	false, 
	false, 
	false, 
	false
	], 
	
	
	[
	"You can preview the ship you will be battling here, in the scouting tab. This will show the next ship's health and any special information about it.", 
	Vector2(450,-10),
	["", "", "", "", ""],
	["", ""],
	true, 
	true, 
	true, 
	true, 
	false, 
	false, 
	false
	], 
	
	[
	"If you ever need to understand a mechanic better, check out the rulebook by clicking here.", 
	Vector2(-560,120),
	["", "", "", "", ""],
	["", ""],
	true, 
	true, 
	true, 
	true, 
	true, 
	false, 
	false
	], 
	
	[
	"Prepare for your first battle by purchasing these stars and asteroids!", 
	Vector2(-737,-37),
	["Astral Husk", "Astral Husk", "Astral Husk", "Iron Rock", "Gilded Husk"],
	["Shield", "Steering Wheel"],
	true, 
	true, 
	true, 
	true, 
	true, 
	false, 
	true
	], 
	
	[
	"To end your turn and begin the battle, click this button. Good luck! Soon enough, you'll need it.", 
	Vector2(441,334),
	["", "", "", "", ""],
	["", ""],
	true, 
	true, 
	true, 
	true, 
	true, 
	true,
	false
	], 
	
	
]
#battledata = {message, message location, timer visible, status effects visible, stats visible, time scale visible}

var battleData = [
	[
	"Welcome to your first battle! Soon, the asteroids you purchased will begin attacking the ship, launching from a random location every 3 seconds.",
	Vector2(960,540),
	false,
	false,
	false,
	false
	],
	
	[
	"When the attack begins, you will have only a short time to defeat the ship. This time is displayed here.",
	Vector2(1331,872),
	true,
	false,
	false,
	false
	],
	
	[
	"When you gain status effects, their icons and quantities will show up here on this left panel, below your [img width=32 height=32]res://ART/icons/moneyIcon.png[/img].",
	Vector2(431,272),
	true,
	true,
	false,
	false
	],
	
	[
	"Some stats of your asteroids will show up here in these boxes - average damage, average speed, permanent damage gained, permanent speed gained, and number of current asteroids (or, asteroids on field that have not been destroyed). For average stats, the average is taken of all current asteroids on the field.",
	Vector2(960,530),
	true,
	true,
	true,
	false
	],
	
	[
	"Let the battle begin! Use this bar to control the speed of time in-battle. Move it off of zero to unpause the fight and begin!",
	Vector2(215,685),
	true,
	true,
	true,
	true
	],
	
]


var index = 0


func _on_rich_text_label_mouse_entered():
	inRange = true
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_rich_text_label_mouse_exited():
	inRange = false
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))

func _ready():
	visible = false
	if !Global.shopTutorialComplete and isShop:
		position = Vector2(0,0)
		index = 0
		var d = dataShop[index]
		$message/CenterContainer/RichTextLabel.text = "[center]" + d[0] + "\n\nClick here to continue"
		$message.position = d[1]
		get_parent().tutorialForce(d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9], d[10])
		visible = true
	elif !Global.battleTutorialComplete and !isShop:
		index = 0
		position = Vector2(0,0)
		$"../HSlider".value = 0
		$"../HSlider".visible = false
		$"../timerLabel".visible = false
		$"../statLabels".visible = false
		$"../VBoxContainer".visible = false
		var d = battleData[index]
		$message/CenterContainer/RichTextLabel.text = "[center]" + d[0] + "\n\nClick here to continue"
		$message.position = d[1]
		visible = true


func _input(event):
	if Input.is_action_just_pressed("click") and inRange:
		if isShop and !Global.shopTutorialComplete:
			index += 1
			if index < dataShop.size():
				var d = dataShop[index]
				$message/CenterContainer/RichTextLabel.text = "[center]" + d[0] + "\n\nClick here to continue"
				$message.position = d[1]
				get_parent().tutorialForce(d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9], d[10])
			else:
				visible = false
				Global.shopTutorialComplete=true
		elif !Global.battleTutorialComplete and !isShop:
			index += 1
			if index < battleData.size():
				var d = battleData[index]
				$message/CenterContainer/RichTextLabel.text = "[center]" + d[0] + "\n\nClick here to continue"
				$message.position = d[1]
				get_parent().get_parent().tutorialForce(d[2], d[3], d[4], d[5])
			else:
				visible = false
				Global.battleTutorialComplete=true
