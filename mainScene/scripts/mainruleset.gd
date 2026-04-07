extends Node2D

#This is separate from main because I want to eventually implement a system where the player 
#can buy new rulesets, altering the objective and changing what gains money/the win and lose
#conditions. I've brainstormed and prototyped this but haven't had time to add it yet 

var hp = 500: set = hurt
var maxHP = 500
var breachAmount = 0: set = changeBreach
var blockAmount = 0: set = changeBlock
var burnoutAmount = 0: set = changeBurnout
var parasiteAmount = 0: set = changeParasite
signal statusEffectChanged

@onready var ship = $"../ship"

func changeBreach(new):
	breachAmount = new
	statusEffectChanged.emit()
	cursedEssence()

func changeBlock(new):
	blockAmount = new
	statusEffectChanged.emit()
	cursedEssence()

func changeBurnout(new):
	burnoutAmount = new
	statusEffectChanged.emit()
	cursedEssence()

func changeParasite(new):
	parasiteAmount = new
	statusEffectChanged.emit()
	cursedEssence()

func cursedEssence():
	var n = Global.numOfStars("Cursed Essence")
	if n > 0:
		for i in n:
			if Global.randChance(50):
				var statusChanged = randi_range(1,4)
				if statusChanged == 1:
					breachAmount += 1
				elif statusChanged == 2:
					Global.block += 1
				elif statusChanged == 3:
					burnoutAmount += 1
				elif statusChanged == 4:
					parasiteAmount += 1
	


func hurt(newHP):
	if ship.phase == 2:
		hp = max(round(newHP),hp-20)
	else:
		hp = round(newHP)
	ship.get_node("hp").get_node("hpbar").max_value = maxHP
	ship.hp = hp
	if hp <= 0 and !$"..".ended:
		$"..".victory()



func _ready():
	$"../rulesTimer".start(round((300+Global.turn*2.4)*pow(1.1,Global.numOfStars("Hourglass"))))
	initializeStats()

func initializeStats():
	maxHP *= pow(1.25,Global.turn)
	if ship.phase == 3:
		maxHP *= 1.5
		hp *= 1.5
		hp = floor(hp)
		maxHP = floor(maxHP)
	hp = maxHP
	breachAmount = 0
	blockAmount = 0
	burnoutAmount = 0
	parasiteAmount = 0
	


func _process(delta):
	if !$"..".ended:
		$"../CanvasLayer/timerLabel".text = str(round($"../rulesTimer".time_left*100)/100)
	if round($"../rulesTimer".time_left*100)/100 < 0.02:
		$"../CanvasLayer/timerLabel".text = "0.00"
		$"..".defeat()

func onHit(asteroid):
	hp -= asteroid.attributes.damage
	var type = Global.asteroidsDeck[asteroid.slot]
	Global.addToLog(type,asteroid.attributes.damage)
	$"../CanvasLayer/log".update()
