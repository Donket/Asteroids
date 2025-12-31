extends Node2D

var launcher
var main

var baseSpeed = 100
var baseAcceleration = 0
var bounces = 0

var damage = 55


func onHit():
	main.money += 2
