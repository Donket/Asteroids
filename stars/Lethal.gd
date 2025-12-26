extends Node2D

var main

func onSpawn(asteroid):
	if Global.health - 2 * pow(2,Global.numOfStars("Steak")) <= 0:
		asteroid.speed *= 1.2
		asteroid.seekRadius *= 1.2
		asteroid.turnSpeed *= 1.2
		asteroid.attributes.damage *= 1.2
		asteroid.attributes.bounces *= 1.2
