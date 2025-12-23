extends Node2D

var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 0

var damage = 10


func onHit():
	main.money += 10
	main.asteroids.pick_random().die()
