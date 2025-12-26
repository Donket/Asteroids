extends Node

var main

func onSpawn(asteroid):
	asteroid.turnSpeed += 20 * max(1,asteroid.acceleration)
	asteroid.seekRadius += 20 * max(1,asteroid.acceleration)
