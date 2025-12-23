extends Node2D

var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 1

var damage = 10


func onBounce():
	if main.money >= 3:
		bounces += 1
		main.money -= 3
