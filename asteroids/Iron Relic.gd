extends Node2D




var launcher
var main

var baseSpeed = 160
var baseAcceleration = 0
var bounces = 0: set = changeBounce

var damage = 165

func onSpawn():
	var level = Global.getLevel(launcher.index)
	bounces = level

func onBounce():
	get_parent().acceleration += 50


func changeBounce(newBounce):
	bounces = newBounce
	var n = Global.numOfStars("Iron Essence")
	if n > 0:
		get_parent().speed *= pow(1.1,n)
