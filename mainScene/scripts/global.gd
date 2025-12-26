extends Camera2D

var asteroidsDeck = ["Gilded Gem", "Gilded Gem", "Gilded Gem", "Gilded Gem", "Gilded Gem", "Gilded Gem"]
#stats = [+speed, +damage] where nums are added to base stats 
var asteroidPermStats = [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0]]
var starsDeck = ["Dice", "Dice", "Dice", "Dice", "Dice", "Dice", "Dice", "Dice", "Dice", "Dice", "Debt Collector", "Golden Tooth", "Debt Collector", "Golden Tooth", "Debt Collector", "Golden Tooth", "Debt Collector", "Golden Tooth", "Piggy Bank"]
var itemGrabbed = null
var overSell = false
var money = 50000

var wins = 0
var maxWins = 10
var health = 10

# item : [cost, rarity]
var itemsToData: Dictionary = {
	"Iron Husk": [100, 0],
	"Iron Rock": [200, 1],
	"Iron Gem": [150, 1],
	"Iron Relic": [300, 2],
	"Iron Meteor": [400, 3],
	"Ancient Husk": [100, 0],
	"Ancient Rock": [250, 1],
	"Ancient Gem": [200, 2],
	"Ancient Relic": [400, 3],
	"Ancient Meteor": [500, 4],
}


# item : [cost, rarity]
var starsToData: Dictionary = {
	"Dice": [100, 0],
	"Boot": [300, 1],
	"Backpack": [150, 0],
	"Pipe": [250, 1],
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
