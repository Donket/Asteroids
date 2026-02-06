extends Node

var launcher
var main

var baseSpeed = 130
var baseAcceleration = 0
var bounces = 0

var damage = 70



func onHit():
	var level = Global.getLevel(launcher.index)
	main.rules.hp -= 40*level*pow(Global.block,1.5)
