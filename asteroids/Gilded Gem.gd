extends Node2D

var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 0

var damage = 10


func onCrash():
	if main.money > 100:
		main.money -= 10
		Global.asteroidPermStats[launcher.index] += [1,1]
