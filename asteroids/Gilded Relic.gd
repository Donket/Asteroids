extends Node2D

var launcher
var main

var baseSpeed = 210
var baseAcceleration = 0
var bounces = 2

var damage = 140


func onBounce():
	var level = Global.getLevel(launcher.index)
	main.money += 5*level
