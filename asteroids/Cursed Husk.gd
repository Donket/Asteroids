extends Node2D

var launcher
var main

var baseSpeed = 110
var baseAcceleration = 0
var bounces = 0

var damage = 45


func onHit():
	var level = Global.getLevel(launcher.index)
	if Global.randChance(50):
		main.money += 3*level
	else:
		main.money -= 2*level
