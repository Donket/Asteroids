extends Node2D



var launcher
var main

var baseSpeed = 110
var baseAcceleration = 0
var bounces = 0

var damage = 55



func onHit():
	if randi_range(0,4) == 2:
		main.get_node("rules").burnoutAmount += 1

