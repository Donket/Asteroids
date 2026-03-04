extends Node2D

var launcher
var main

var baseSpeed = 170
var baseAcceleration = 0
var bounces = 0

var damage = 95


func onHit():
	var level = Global.getLevel(launcher.index)
	if randf_range(0,1) > 0.5:
		main.get_node("rules").breachAmount += 1+level
	else:
		main.get_node("rules").burnoutAmount += level
