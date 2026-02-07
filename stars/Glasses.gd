extends Node2D

var main

func onSpawn(asteroid):
	if Global.block >= 3:
		Global.block -= 3
		asteroid.seekRadius *= 5
		asteroid.turnSpeed *= 5
