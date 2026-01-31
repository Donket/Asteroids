extends Node2D

var launcher
var main

var baseSpeed = 160
var baseAcceleration = 0
var bounces = 1

var damage = 165


func onBounce():
	var level = Global.getLevel(launcher.index)
	bounces += 1
	damage -= (20-5*level)
