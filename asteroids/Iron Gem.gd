extends Node2D




var launcher
var main

var baseSpeed = 230
var baseAcceleration = 0
var bounces = 0

var damage = 100



func onHit():
	var level = Global.getLevel(launcher.index)
	main.get_node("rules").breachAmount += level

