extends Camera2D

var battleScene = null

var asteroidsDeck = ["Cursed Relic", "Cursed Relic", "Cursed Relic", "Cursed Relic", "Cursed Relic", "Cursed Relic"]
#stats = [+speed, +damage] where nums are added to base stats 
var asteroidPermStats = [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0]]
var asteroidExps = [0,0,0,0,0,0]
var starsDeck = ["Boot", "Blind Stick", "Binky", "Binky", "Binky", "Wagon Wheel"]
var itemGrabbed = null
var overSell = false
var itemsSaved = false
var savedItems = []
var savedRollPrice = 5
var money = 600

var wins = 0
var maxWins = 10
var health = 10

var turn = 100
var timeScale = 1
var shopTutorialComplete = true
var battleTutorialComplete = true

var logData = {
	
}

var itemsToDesc = {
	
	# --- IRON FAMILY ---
	"Iron Husk": {
		"text": "Has: {bounces} [img]res://ART/icons/bounceIcon.png[/img]",
		"base": {"bounces": 1},
		"gain": {"bounces": 1}
	},
	"Iron Rock": {
		"text": "On Crash: [img]res://ART/icons/spawnIcon.png[/img] {count} Iron Husk",
		"base": {"count": 1},
		"gain": {"count": 2}
	},
	"Iron Gem": {
		"text": "On Hit: Apply {breach} [img]res://ART/icons/breachIcon.png[/img]",
		"base": {"breach": 1},
		"gain": {"breach": 1}
	},
	"Iron Relic": {
		"text": "On Bounce: Gain Acceleration\nHas: {bounces} [img]res://ART/icons/bounceIcon.png[/img]",
		"base": {"bounces": 1},
		"gain": {"bounces": 1}
	},
	"Iron Meteor": {
		"text": "On Hit: [img]res://ART/icons/spawnIcon.png[/img] {count} random Irons",
		"base": {"count": 2},
		"gain": {"count": 2}
	},

	# --- ANCIENT FAMILY ---
	"Ancient Husk": {
		"text": "On Hit: Apply [img]res://ART/icons/burnoutIcon.png[/img] ({chance}% chance)",
		"base": {"chance": 25},
		"gain": {"chance": 25}
	},
	"Ancient Rock": {
		"text": "On Hit: 30% chance to apply {parasite} [img]res://ART/icons/parasiteIcon.png[/img]",
		"base": {"parasite": 1},
		"gain": {"parasite": 2}
	},
	"Ancient Gem": {
		"text": "On Hit: Activates [img]res://ART/icons/breachIcon.png[/img] {count} times",
		"base": {"count": 1},
		"gain": {"count": 1}
	},
	"Ancient Relic": {
		"text": "On Crash: [img]res://ART/icons/spawnIcon.png[/img] {count} random Relic (can't spawn Ancient Relic)",
		"base": {"count": 1},
		"gain": {"count": 1}
	},
	"Ancient Meteor": {
		"text": "On Crash: [img]res://ART/icons/spawnIcon.png[/img] {count} Ancients",
		"base": {"count": 3},
		"gain": {"count": 3}
	},

	# --- CURSED FAMILY ---
	"Cursed Husk": {
		"text": "On Hit: 50% chance + {win} [img]res://ART/icons/moneyIcon.png[/img]\nOtherwise - {loss} [img]res://ART/icons/moneyIcon.png[/img]",
		"base": {"win": 3, "loss": 2},
		"gain": {"win": 3, "loss": 1}
	},
	"Cursed Rock": {
		"text": "On Crash: 50% chance [img]res://ART/icons/spawnIcon.png[/img] a random Rock, 50% chance gain +{dmg} permanent damage",
		"base": {"dmg": 5},
		"gain": {"dmg": 5}
	},
	"Cursed Gem": {
		"text": "On Hit: 50% chance to apply {breach} [img]res://ART/icons/breachIcon.png[/img], 50% chance to apply {burnout} [img]res://ART/icons/burnoutIcon.png[/img]",
		"base": {"breach": 2, "burnout": 1},
		"gain": {"breach": 1, "burnout": 1}
	},
	"Cursed Relic": {
		"text": "Has: 1 [img]res://ART/icons/bounceIcon.png[/img]\nOn Bounce: + 1 [img]res://ART/icons/bounceIcon.png[/img] - {pen} damage (negative penalty does nothing)",
		"base": {"pen": 20},
		"gain": {"pen": -10}
	},
	"Cursed Meteor": {
		"text": "On Hit: [img]res://ART/icons/spawnIcon.png[/img] {count} Cursed. Each has a 50% chance to be destroyed immediately",
		"base": {"count": 4},
		"gain": {"count": 4}
	},

	# --- GILDED FAMILY ---
	"Gilded Husk": {
		"text": "On Hit: Gain +{money} [img]res://ART/icons/moneyIcon.png[/img]",
		"base": {"money": 5},
		"gain": {"money": 5}
	},
	"Gilded Rock": {
		"text": "Has: 1 [img]res://ART/icons/bounceIcon.png[/img]\nOn Bounce: Spend {cost} [img]res://ART/icons/moneyIcon.png[/img] to gain + 1 [img]res://ART/icons/bounceIcon.png[/img].",
		"base": {"cost": 3},
		"gain": {"cost": -1}
	},
	"Gilded Gem": {
		"text": "On Crash: Convert 10 [img]res://ART/icons/moneyIcon.png[/img] into +{stat} permanent damage and +{stat} permanent speed",
		"base": {"stat": 4},
		"gain": {"stat": 4}
	},
	"Gilded Relic": {
		"text": "On Bounce: Gain +{money} [img]res://ART/icons/moneyIcon.png[/img]\nHas: {bounces} [img]res://ART/icons/bounceIcon.png[/img]",
		"base": {"money": 10, "bounces": 2},
		"gain": {"money": 5, "bounces": 1}
	},
	"Gilded Meteor": {
		"text": "On Hit: +{money} [img]res://ART/icons/moneyIcon.png[/img]\nLose 1 random asteroid",
		"base": {"money": 100},
		"gain": {"money": 100}
	},

	# --- ASTRAL FAMILY ---
	"Astral Husk": {
		"text": "On Spawn: 50% chance +{block} [img]res://ART/icons/blockIcon.png[/img]",
		"base": {"block": 1},
		"gain": {"block": 1}
	},
	"Astral Rock": {
		"text": "On Bounce: +{block} [img]res://ART/icons/blockIcon.png[/img]",
		"base": {"block": 1},
		"gain": {"block": 1}
	},
	"Astral Gem": {
		"text": "On Shot: Convert all parasite, breach, and burnout into block, multiplied by {multi}.",
		"base": {"multi": 1},
		"gain": {"multi": 0.5}
	},
	"Astral Relic": {
		"text": "On Spawn: Gain a {perc}% boost of all stats. This effect is multiplied by current [img]res://ART/icons/blockIcon.png[/img].",
		"base": {"perc": 0.5},
		"gain": {"perc": 1}
	},
	"Astral Meteor": {
		"text": "Oh Hit: Use all your block to deal {mult} base damage. This scales exponentially with [img]res://ART/icons/blockIcon.png[/img].",
		"base": {"mult": 5},
		"gain": {"mult": 5}
	},

	# Stars
	
	"Boot":
		"When you gain a status effect, all asteroids gain +3 acceleration.",
	"Hourglass":
		"Timer is 10% longer.",
	"Steering Wheel":
		"Asteroids steer towards the ship more directly. This effect increases with asteroid acceleration.",
	"Loose Change":
		"On Crash: 30% chance to drop +8 [img]res://ART/icons/moneyIcon.png[/img]",
	"Payday":
		"At the start of each round, + 40 [img]res://ART/icons/moneyIcon.png[/img]",
	"Trampoline":
		"On spawn, asteroids have a 30% chance to gain 1 [img]res://ART/icons/bounceIcon.png[/img]",
	"Tip Jar":
		"Each On Hit effect has a 40% chance to grant +6 [img]res://ART/icons/moneyIcon.png[/img]",
	"Shield":
		"On Bounce: Gain +1 [img]res://ART/icons/blockIcon.png[/img]",
	"Glasses":
		"On Spawn: Spend 3 [img]res://ART/icons/blockIcon.png[/img] and gain 400% ship tracking",
	"Candle":
		"On Spawn: 20% chance to apply [img]res://ART/icons/burnoutIcon.png[/img].",
	"Blind Stick":
		"Asteroids steer away from the ship.",
	"Binky":
		"On Bounce: 20% chance to apply + 1 [img]res://ART/icons/breachIcon.png[/img].",
	"Dice":
		"Random chances +10% (cannot stack above 90%)",
	"Hanger":
		"Upon spawning an asteroid, 20% chance to destroy it and gain +10 [img]res://ART/icons/moneyIcon.png[/img]",
	"Snowmelt":
		"On Hit: Convert 1 [img]res://ART/icons/blockIcon.png[/img] to 1 [img]res://ART/icons/burnoutIcon.png[/img].",
	"Backpack":
		"When you gain a status effect, 30% chance to gain 5 money",
	"Bulldozer":
		"On Crash: Gain block proportional to asteroid speed",
	"Snowball":
		"As asteroids accelerate, they gain size.",
	"Goop":
		"Asteroids gain +1 [img]res://ART/icons/bounceIcon.png[/img].
On bounce: 40% chance to apply +2 [img]res://ART/icons/breachIcon.png[/img].",
	"Steak":
		"Each win gives double victories, and each loss takes double lives.",
	"Radish":
		"On Hit: Convert 5 [img]res://ART/icons/blockIcon.png[/img] into +3 permanent damage",
	"Friendly Customer":
		"Each star you obtain reduces the cost of future stars by 2%",
	"Glass Cannon":
		"When you would gain [img]res://ART/icons/blockIcon.png[/img], instead give all current asteroids +3 temporary damage",
	"Lethal":
		"If you will die next loss, all asteroid stats +20%",
	"Sandpaper":
		"On Bounce: Convert all damage into [img]res://ART/icons/burnoutIcon.png[/img] equal to 1% of damage",
	"Golden Tooth":
		"Whenever you gain [img]res://ART/icons/moneyIcon.png[/img], gain +3 extra",
	"Coupon Book":
		"Future items cost 20% less, but rerolls cost 20% more",
	"Suicide Bomb":
		"On Crash, each asteroid has a 20% chance to deal 50 damage to the ship.",
	"Coconut":
		"On Crash: Convert 2 [img]res://ART/icons/burnoutIcon.png[/img] into 3 [img]res://ART/icons/blockIcon.png[/img]",
	"Recursive":
		"On Crash: If this is the first asteroid of the battle, respawn it. Does not stack.",
	"Mirror":
		"On Bounce: Deal 20% of asteroid damage to ship.",
	"Spider":
		"All asteroid stats +20%. - 10 [img]res://ART/icons/moneyIcon.png[/img] when destroyed.",
	"Snowman":
		"If you have at least four snowballs, -65% launch time to all asteroids",
	"Throw Pillow":
		"Each asteroid that spawns has a 5% chance on spawn to teleport to a random location motionless. After 5 seconds, it gains back its base speed and double its other stats.",
	"Bottle":
		"When an asteroid spawns, 10% chance to give the asteroid in Slot 4 +2 permanent damage.",
	"Speedometer":
		"Gain 1 [img]res://ART/icons/moneyIcon.png[/img] per second, multiplied by 10% of average asteroid speed.",
	"Debt Collector":
		"Every time you gain money in battle, 10% chance to spawn a copy of the asteroid in Slot 3 on top of the ship.",
	"Minivan":
		"Gain 3 asteroid acceleration for each asteroid on screen.",
	"Shotgun":
		"Each time an asteroid is launched, 20% chance to launch an extra and 5% chance to launch two extra.",
	"Rose":
		"Every four seconds, trigger all star On Spawn effects on a random existing asteroid.",
	"Death Rattle":
		"On Crash: Trigger On Bounce effects.",
	"Pipe":
		"On Hit effects have a 20% chance of triggering twice (Does not affect star abilities).",
	"Warhammer":
		"On Hit: Deal damage equal to double the sum of all status effects.",
	"Piggy Bank":
		"Unspent [img]res://ART/icons/moneyIcon.png[/img] grants +1% asteroid stats per 200 money",
	"Light Fingers":
		"On purchasing a shop item, 5% chance to also obtain all stars in shop.",
	"Wagon Wheel":
		"If an asteroid's acceleration ever reaches 100, return to base speed and acceleration and gain 5 [img]res://ART/icons/burnoutIcon.png[/img] and 5 [img]res://ART/icons/bounceIcon.png[/img].",
	"Iron Essence":
		"Whenever an Iron asteroid gains bounce, it gains +10% of existing speed.",
	"Astral Essence":
		"Whenever you gain money, existing Astral asteroids gain +5 damage.",
	"Gilded Essence":
		"Whenever a Gilded asteroid gains speed from an ability, gain +5 [img]res://ART/icons/moneyIcon.png[/img].",
	"Cursed Essence":
		"Whenever you gain a status effect, 50% chance to also gain another.",
	"Ancient Essence":
		"If you ever have more than 30 status effects, spend all to gain 50 damage on all existing asteroids."

#TODO: Low prio: Implement
	#"Douglas":
#"He's just here for the ride. Every round, 15% chance to turn another star into Douglas."
}

func getDesc(item, level):
	var data = itemsToDesc[item]
	var placeholders = {}
	for stat in data["base"].keys():
		var base=data["base"][stat]
		var gain=data["gain"][stat]
		placeholders[stat]=base+(gain*(level-1))
	return data["text"].format(placeholders)


func resetGlobalData():
	battleScene = null
	asteroidsDeck = [null, null, null, null, null, null]
	asteroidPermStats = [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0]]
	asteroidExps = [0,0,0,0,0,0]
	starsDeck = []
	itemGrabbed = null
	overSell = false
	money = 300
	wins = 0
	maxWins = 10
	health = 10
	turn = 0
	logData = {}

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
	"Hourglass": [100, 0],
	"Steering Wheel": [110, 0],
	"Loose Change": [90, 0],
	"Payday": [110, 0],
	"Trampoline": [90, 0],
	"Tip Jar": [85, 0],
	"Shield": [85, 0],
	"Glasses": [100, 0],
	"Candle": [100, 0],
	"Blind Stick": [80, 0],
	"Binky": [120, 0],

	"Dice": [140, 1],
	"Hanger": [90, 1],
	"Snowmelt": [140, 1],
	"Backpack": [150, 1],
	"Bulldozer": [150, 1],
	"Snowball": [135, 1],
	"Goop": [130, 1],

	"Steak": [160, 2],
	"Radish": [160, 2],
	"Friendly Customer": [145, 2],
	"Glass Cannon": [135, 2],
	"Lethal": [170, 2],
	"Sandpaper": [160, 2],
	"Golden Tooth": [180, 2],
	"Coupon Book": [140, 2],
	"Suicide Bomb": [120, 2],
	"Coconut": [120, 2],
	"Recursive": [200, 2],
	"Mirror": [150, 2],

	"Spider": [260, 3],
	"Snowman": [280, 3],
	"Throw Pillow": [250, 3],
	"Bottle": [230, 3],
	"Speedometer": [250, 3],
	"Debt Collector": [280, 3],
	"Minivan": [290, 3],
	"Shotgun": [280, 3],
	"Rose": [280, 3],
	"Death Rattle": [280, 3],

	"Pipe": [500, 4],
	"Warhammer": [500, 4],
	"Piggy Bank": [500, 4],
	"Light Fingers": [500, 4],
	"Wagon Wheel": [500, 4],
	"Iron Essence": [750, 4],
	"Astral Essence": [750, 4],
	"Gilded Essence": [750, 4],
	"Cursed Essence": [750, 4],
	"Ancient Essence": [750, 4],
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


func addToLog(source, damage):
	if battleScene.ship.phase == 2 and damage > 50:
		damage = 50
	else:
		damage = round(damage)
	if source in logData.keys():
		logData[source] += damage
	else:
		logData[source] = damage
	battleScene.get_node("CanvasLayer/log").update()

func camShake(intensity):
	battleScene.camShake(intensity)
