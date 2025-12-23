extends Node2D




var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 0

var damage = 20



func onHit():
	main.get_node("rules").breachAmount += 1

