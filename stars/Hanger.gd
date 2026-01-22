extends Node

var main

func onSpawn(asteroid):
	if randf_range(0,1) < 0.2:
		main.money += 4
		asteroid.die()
