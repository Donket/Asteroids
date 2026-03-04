extends Node

var main

func onSpawn(asteroid):
	if Global.randChance(10):
		Global.asteroidPermStats[3][1] += 2
