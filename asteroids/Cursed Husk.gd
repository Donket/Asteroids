extends Node2D

var launcher
var main

var baseSpeed = 110
var baseAcceleration = 0
var bounces = 0

var damage = 45


func onHit():
	if Global.randChance(50):
		main.money += 3
	else:
		main.money -= 2
