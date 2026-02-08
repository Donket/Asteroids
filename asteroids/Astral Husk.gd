extends Node

var launcher
var main

var baseSpeed = 90
var baseAcceleration = 0
var bounces = 0

var damage = 35



func onHit():
	var level = Global.getLevel(launcher.index)
	if Global.randChance(50):
		main.rules.blockAmount += level
