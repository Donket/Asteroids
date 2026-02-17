extends Node

var main

func onSpawn(asteroid):
	if Global.randChance(20):
		main.rules.burnoutAmount += 1
