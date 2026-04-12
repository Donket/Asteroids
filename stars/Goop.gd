extends Node

var main

func onSpawn(asteroid):
	asteroid.attributes.bounces += 1

func onBounce(asteroid):
	if Global.randChance(40):
		main.rules.burnoutAmount += 1
