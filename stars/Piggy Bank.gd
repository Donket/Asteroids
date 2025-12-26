extends Node

var main

func onSpawn(asteroid):
	var money = main.money
	var percentage = 0
	while money >= 200:
		percentage += 0.01
		money -= 200
	asteroid.speed *= (1+percentage)
	asteroid.seekRadius *= (1+percentage)
	asteroid.turnSpeed *= (1+percentage)
	asteroid.attributes.damage *= (1+percentage)
	asteroid.attributes.bounces *= (1+percentage)
