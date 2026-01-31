extends Node2D



var launcher
var main

var baseSpeed = 110
var baseAcceleration = 0
var bounces = 0

var damage = 55



func onHit():
	var level = Global.getLevel(launcher.index)
	if Global.randChance(25*level):
		main.get_node("rules").burnoutAmount += 1

