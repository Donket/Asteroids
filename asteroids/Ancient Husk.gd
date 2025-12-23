extends Node2D



var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 0

var damage = 10


func onBounce():
	pass

func onCrash():
	pass

func onHit():
	if randi_range(0,4) == 2:
		main.get_node("rules").burnoutAmount += 1

