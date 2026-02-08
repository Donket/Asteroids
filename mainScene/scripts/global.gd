extends Camera2D

var battleScene = null

var asteroidsDeck = [null, null, null, null, null, null]
#stats = [+speed, +damage] where nums are added to base stats 
var asteroidPermStats = [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0]]
var asteroidExps = [0,0,0,0,0,0]
var starsDeck = []
var itemGrabbed = null
var overSell = false
var money = 300

var wins = 0
var maxWins = 10
var health = 10

var turn = 0
var firstOpen = true

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
"On Hit: +100 [img]res://ART/icons/moneyIcon.png[/img]
Lose 1 random asteroid",

	# Astral Family
	"Astral Husk":
"On Spawn: 50% chance +1 [img]res://ART/icons/blockIcon.png[/img]",

	"Astral Rock":
"On Bounce: +1 [img]res://ART/icons/blockIcon.png[/img]",

	"Astral Gem":
"On Shot: Convert all parasite, breach, and burnout into block.",

	"Astral Relic":
"On Spawn: Gain a small percentage boost of all stats which scales with block",

	"Astral Meteor":
"Oh Hit: Use all your block to deal huge damage which increases with block.",

	# Stars
	
	"Dice": 
"Random chances +10% (cannot stack above 90%)",
	"Boot": 
"Asteroid Acceleration +30",
	"Backpack": 
"Asteroids gain 1% speed for each Star you own",
	"Trampoline": 
"On spawn, asteroids have a 30% chance to gain 1 bounce",
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
	"Bulldozer":
"On Crash: Gain block proportional to asteroid speed",
	"Coconut": 
"On Crash: Convert 2 [img]res://ART/icons/burnoutIcon.png[/img] into 3 [img]res://ART/icons/blockIcon.png[/img]",
	"Glass Cannon": 
"When you would gain shield, instead give all current asteroids +3 temporary damage",
	"Glasses": 
"On Spawn: Spend 3 [img]res://ART/icons/blockIcon.png[/img] and gain 400% ship tracking",
	"Radish": 
"On Hit: Convert 5 [img]res://ART/icons/blockIcon.png[/img] into +3 permanent damage",
	"Shield": 
"On Bounce: Gain +1 [img]res://ART/icons/blockIcon.png[/img]",
	"Snowman": 
"If you have at least three snowballs, -30% launch time to all asteroids",
	"Warhammer": 
"On Hit: Deal damage equal to three times the sum of all effects.",
#TODO: Low prio: Implement
	#"Douglas":
#"He's just here for the ride. Every round, 15% chance to turn another star into Douglas."
}

# item : [cost, rarity, speed, damage]
var itemsToData: Dictionary = {
	"Ancient Husk": [50, 0, 110, 55],
	"Iron Husk": [40, 0, 120, 40],
	"Astral Husk": [50, 0, 90, 35],
	"Cursed Husk": [55, 1, 110, 45],
	"Gilded Husk": [45, 1, 100, 55],

	"Ancient Rock": [120, 1, 130, 70],
	"Iron Rock": [135, 1, 110, 80],
	"Astral Rock": [135, 1, 90, 50],
	"Cursed Rock": [140, 2, 120, 80],
	"Gilded Rock": [160, 2, 130, 85],

	"Ancient Gem": [170, 2, 230, 95],
	"Iron Gem": [190, 2, 230, 100],
	"Astral Gem": [180, 2, 150, 70],
	"Cursed Gem": [270, 3, 170, 95],
	"Gilded Gem": [275, 3, 200, 105],

	"Ancient Relic": [355, 3, 200, 105],
	"Iron Relic": [355, 3, 160, 165],
	"Astral Relic": [355, 3, 160, 90],
	"Cursed Relic": [305, 3, 160, 165],
	"Gilded Relic": [415, 3, 210, 140],

	"Ancient Meteor": [1000, 4, 230, 210],
	"Iron Meteor": [1000, 4, 210, 205],
	"Astral Meteor": [1000, 4, 200, 150],
	"Cursed Meteor": [1000, 4, 210, 180],
	"Gilded Meteor": [1000, 4, 180, 300]

}

var starsToData: Dictionary = {
	"Boot": [80, 0],
	"Hanger": [90, 1],
	"Hourglass": [100, 0],
	"Steering Wheel": [110, 0],
	"Loose Change": [90, 0],
	"Payday": [110, 0],
	"Trampoline": [90, 0],
	"Tip Jar": [85, 1],
	"Shield": [85, 0],
	"Glasses": [100, 0],

	"Dice": [140, 1],
	"Backpack": [150, 1],
	"Bulldozer": [150, 1],
	"Goop": [130, 2],
	"Steak": [160, 2],
	"Radish": [160, 2],
	"Friendly Customer": [145, 2],
	"Snowball": [135, 2],
	"Glass Cannon": [135, 2],
	"Lethal": [170, 2],
	"Golden Tooth": [180, 2],
	"Coupon Book": [140, 2],
	"Binky": [150, 2],
	"Suicide Bomb": [120, 2],
	"Coconut": [120, 2],

	"Spider": [260, 3],
	"Snowman": [280, 3],
	"Throw Pillow": [250, 3],
	"Bottle": [230, 3],
	"Speedometer": [250, 3],
	"Debt Collector": [280, 3],
	"Minivan": [290, 3],
	"Shotgun": [280, 3],

	"Pipe": [500, 4],
	"Warhammer": [500, 4],
	"Piggy Bank": [500, 4],
	"Light Fingers": [500, 4]
}


var block = 0: set = updateBlock

func updateBlock(newBlock):
	var num = numOfStars("Glass Cannon")
	if num == 0:
		block = newBlock
		battleScene.rules.blockAmount = block
	else:
		for ast in battleScene.asteroids:
			if ast != null and is_instance_valid(ast):
				ast.attributes.damage += 3*num

func hit():
	if block > 0:
		block -= 1
		return false
	else:
		return true

func numOfStars(star):
	var num = 0
	for deckStar in starsDeck:
		if deckStar == star:
			num += 1
	return num


func randChance(percent):
	if randi_range(0,100) < min(90,percent + 10 * numOfStars("Dice")):
		return true
	return false


func getLevel(ind):
	return (asteroidExps[ind] - asteroidExps[ind] % 3)/3 + 1
