extends Node2D

var launcher
var main

var baseSpeed = 130
var baseAcceleration = 0
var bounces = 1

var damage = 85


func onBounce():
	if main.money >= 3:
		bounces += 1
		main.money -= 3
