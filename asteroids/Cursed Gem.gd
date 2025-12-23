extends Node2D

var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 0

var damage = 10


func onCrash():
	if randf_range(0,1) > 0.5:
		main.get_node("rules").breachAmount += 1
	else:
		main.get_node("rules").burnoutAmount += 1
