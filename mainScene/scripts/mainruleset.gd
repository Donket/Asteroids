extends Node2D

#This is separate from main because I want to eventually implement a system where the player 
#can buy new rulesets, altering the objective and changing what gains money/the win and lose
#conditions. I've brainstormed and prototyped this but haven't had time to add it yet 

var hp = 20: set = hurt
var maxHP = 20
var money = Global.money: set = changeMoney
var breachAmount = 0
var burnoutAmount = 0
var parasiteAmount = 0
@onready var ship = $"../ship"

func changeMoney(newMoney):
	money = newMoney
	Global.money = newMoney
	$"../CanvasLayer/moneyLabel".text = str(newMoney)

func hurt(newHP):
	hp = newHP
	$"../ship".get_node("hp").get_node("hpbar").value = hp
	$"../ship".get_node("hp").get_node("hpbar").max_value = maxHP
	if newHP <= 0 and !$"..".ended:
		$"..".victory()
	money += 13

func onBounce(asteroid):
	asteroid.speed *= 1.2

func _ready():
	$"../CanvasLayer/timerLabel".visible = true
	$"../rulesTimer".start(20)
	changeMoney(money)
	
	

func _process(delta):
	if !$"..".ended:
		$"../CanvasLayer/timerLabel".text = str(round($"../rulesTimer".time_left*100)/100)
	if round($"../rulesTimer".time_left*100)/100 < 0.02:
		$"../CanvasLayer/timerLabel".text = "0.00"
		$"..".defeat()

func onHit(asteroid):
	hp -= asteroid.attributes.damage

