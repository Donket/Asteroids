extends Node2D

var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 2

var damage = 10


func onBounce():
	main.money += 5
