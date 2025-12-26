extends Node2D


var main

func onSpawn(asteroid):
	asteroid.speed *= 1.2
	asteroid.seekRadius *= 1.2
	asteroid.turnSpeed *= 1.2
	asteroid.attributes.damage *= 1.2
	asteroid.attributes.bounces *= 1.2

func onCrash(asteroid):
	main.money -= 10
