extends Node2D




var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 0


var damage = 15



func onHit():
	main._on_breach_timer_timeout()

