extends Node

var main

func onSpawn(asteroid):
	if Global.randChance(20):
		main.money += 10
		asteroid.die()
