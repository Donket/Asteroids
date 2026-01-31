extends Node2D

var launcher
var main

var baseSpeed = 200
var baseAcceleration = 0
var bounces = 0

var damage = 105


func onCrash():
	var level = Global.getLevel(launcher.index)
	if main.money > 100:
		main.money -= 10
		Global.asteroidPermStats[launcher.index][0] += 4*level
		Global.asteroidPermStats[launcher.index][1] += 4*level
