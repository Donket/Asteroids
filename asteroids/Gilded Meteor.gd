extends Node2D

var launcher
var main

var baseSpeed = 180
var baseAcceleration = 0
var bounces = 0

var damage = 1#300


func onHit():
	main.money += 100
	var asteroid = main.asteroids.pick_random()
	while asteroid == null:
		asteroid = main.asteroids.pick_random()
	asteroid.die()
