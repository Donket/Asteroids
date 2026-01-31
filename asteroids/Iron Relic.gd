extends Node2D




var launcher
var main

var baseSpeed = 160
var baseAcceleration = 0
var bounces = 1

var damage = 165



func onBounce():
	var level = Global.getLevel(launcher.index)
	get_parent().acceleration += 50*level

