extends Control

var maxHP = 500
var isBossRound = false
var turn = 0

func _ready():
	turn = Global.turn+1
	maxHP *= pow(1.15,turn)
	if Global.wins + 1*pow(2,Global.numOfStars("Steak")) >= Global.maxWins:
		maxHP *= 3
		isBossRound = true
	$Sprite2D/RichTextLabel.text += str(round(maxHP))
	var count = max(0,floor((turn+1)/2)-1)
	if count > 1:
		$Sprite2D/RichTextLabel2.text += "Shoots " + str(count) + " bullets at once."
	if isBossRound:
		$Sprite2D/RichTextLabel2.text += " Fires at all asteroids every 5 secs"
		$Sprite2D/Sprite2D2.animation = "boss"
