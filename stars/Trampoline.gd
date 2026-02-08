extends Node

var main

func onSpawn(asteroid):
	if Global.randChance(30):
		asteroid.get_node("attributes").bounces += 1
