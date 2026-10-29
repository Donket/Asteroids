extends Node

var main

func onSpawn(asteroid):
	main.rules.hp -= asteroid.attributes.damage * 0.2
	Global.addToLog("Mirror",asteroid.attributes.damage * 0.2)
