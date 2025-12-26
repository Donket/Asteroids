extends Node

var main

func onSpawn(asteroid):
	if asteroid.attributes.launcher.index == 0:
		asteroid.attributes.bounces += 2

func onBounce(asteroid):
	if asteroid.attributes.launcher.index == 0:
		asteroid.speed -= 20
