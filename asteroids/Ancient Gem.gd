extends Node2D




var launcher
var main

var baseSpeed = 230
var baseAcceleration = 0
var bounces = 0


var damage = 95



func onHit():
	main._on_breach_timer_timeout()

