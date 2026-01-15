extends Node

var main

func onSpawn(asteroid):
	if randf_range(0,100) < 10:
		Global.asteroidPermStats[3][0] += 2
