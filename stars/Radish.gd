extends Node

var main

func onSpawn(asteroid):
	if Global.block >= 5:
		Global.block -= 5
		Global.asteroidPermStats[asteroid.get_node("attributes").launcher.index][0] += 2
