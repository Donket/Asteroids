extends Node

var launcher
var main

var baseSpeed = 200
var baseAcceleration = 0
var bounces = 0

var damage = 150



func onHit():
	var level = Global.getLevel(launcher.index)
	main.rules.hp -= 5*level*pow(Global.block,1.5)
