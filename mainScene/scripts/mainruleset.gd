extends Node2D

#This is separate from main because I want to eventually implement a system where the player 
#can buy new rulesets, altering the objective and changing what gains money/the win and lose
#conditions. I've brainstormed and prototyped this but haven't had time to add it yet 

var hp = 200: set = hurt
var maxHP = 200
var breachAmount = 0
var burnoutAmount = 0
var parasiteAmount = 0
@onready var ship = $"../ship"

func hurt(newHP):
	if hp > newHP:
		hp = newHP
		$"../ship".get_node("hp").get_node("hpbar").value = hp
		if newHP <= 0 and !$"..".ended:
			$"..".victory()
		get_parent().money += 13
	else:
		hp = newHP
	


func _ready():
	$"../CanvasLayer/timerLabel".visible = true
	$"../rulesTimer".start(20*pow(1.1,Global.numOfStars("Hourglass")))
	initializeStats()

func initializeStats():
	hp *= pow(1.6,Global.turn)
	maxHP = hp
	$"../ship".get_node("hp").get_node("hpbar").value = hp
	$"../ship".get_node("hp").get_node("hpbar").max_value = maxHP
	


func _process(delta):
	if !$"..".ended:
		$"../CanvasLayer/timerLabel".text = str(round($"../rulesTimer".time_left*100)/100)
	if round($"../rulesTimer".time_left*100)/100 < 0.02:
		$"../CanvasLayer/timerLabel".text = "0.00"
		$"..".defeat()

func onHit(asteroid):
	hp -= asteroid.attributes.damage

