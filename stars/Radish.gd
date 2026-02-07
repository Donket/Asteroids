extends Node

var main

func onSpawn(asteroid):
	if Global.block >= 5:
		Global.block -= 5
		Global.asteroidPermStats[asteroid.slot][0] += 2
