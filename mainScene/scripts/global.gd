extends Camera2D

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

var turn = 10
var firstOpen = true

# item : [cost, rarity, speed, damage]
var itemsToData: Dictionary = {
	"Ancient Husk": [50, 0, 110, 55],
	"Iron Husk": [40, 0, 120, 40],
	"Cursed Husk": [55, 1, 110, 45],
	"Gilded Husk": [45, 1, 100, 55],

	"Ancient Rock": [120, 1, 130, 70],
	"Iron Rock": [135, 1, 110, 80],
	"Cursed Rock": [140, 2, 120, 80],
	"Gilded Rock": [160, 2, 130, 85],

	"Ancient Gem": [170, 2, 230, 95],
	"Iron Gem": [190, 2, 230, 100],
	"Cursed Gem": [270, 3, 170, 95],
	"Gilded Gem": [275, 3, 200, 105],

	"Ancient Relic": [355, 3, 200, 105],
	"Iron Relic": [355, 3, 160, 165],
	"Cursed Relic": [305, 3, 160, 165],
	"Gilded Relic": [415, 3, 210, 140],

	"Ancient Meteor": [1000, 4, 230, 210],
	"Iron Meteor": [1000, 4, 210, 205],
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
	"Tip Jar": [85, 1],

	"Dice": [140, 1],
	"Backpack": [150, 1],
	"Goop": [130, 2],
	"Steak": [160, 2],
	"Friendly Customer": [145, 2],
	"Snowball": [135, 2],
	"Lethal": [170, 2],
	"Golden Tooth": [180, 2],
	"Coupon Book": [140, 2],
	"Binky": [150, 2],
	"Suicide Bomb": [120, 2],

	"Spider": [260, 3],
	"Throw Pillow": [250, 3],
	"Bottle": [230, 3],
	"Speedometer": [250, 3],
	"Debt Collector": [280, 3],
	"Minivan": [290, 3],
	"Shotgun": [280, 3],

	"Pipe": [500, 4],
	"Piggy Bank": [500, 4],
	"Light Fingers": [500, 4]
}



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
