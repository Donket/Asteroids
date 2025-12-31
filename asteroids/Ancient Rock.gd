extends Node2D



var launcher
var main

var baseSpeed = 130
var baseAcceleration = 0
var bounces = 0

var damage = 70



func onHit():
	main.get_node("rules").parasiteAmount += 1

