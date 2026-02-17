extends Node2D

var launcher
var main

var baseSpeed = 120
var baseAcceleration = 0
var bounces = 0: set = changeBounce

var damage = 40

func onSpawn():
	var level = Global.getLevel(launcher.index)
	bounces = level



func changeBounce(newBounce):
	bounces = newBounce
	var n = Global.numOfStars("Iron Essence")
	if n > 0:
		get_parent().speed *= pow(1.1,n)
