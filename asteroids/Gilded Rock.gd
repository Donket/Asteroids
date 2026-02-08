extends Node2D

var launcher
var main

var baseSpeed = 130
var baseAcceleration = 0
var bounces = 1

var damage = 85


func onBounce():
	var level = Global.getLevel(launcher.index)
	if main.money >= 4-level:
		bounces += 1
		main.money -= (4-level)
