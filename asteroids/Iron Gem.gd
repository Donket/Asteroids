extends Node2D




var launcher
var main

var baseSpeed = 230
var baseAcceleration = 0
var bounces = 0: set = changeBounce

var damage = 100


func changeBounce(newBounce):
	bounces = newBounce
	var n = Global.numOfStars("Iron Essence")
	if n > 0:
		get_parent().speed *= pow(1.1,n)

func onHit():
	var level = Global.getLevel(launcher.index)
	main.get_node("rules").breachAmount += level

