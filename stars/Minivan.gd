extends Node

var main

func onSpawn(asteroid):
	asteroid.acceleration += 3*main.asteroids.size()
