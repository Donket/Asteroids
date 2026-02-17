extends Node

var main

func onSpawn(asteroid):
	if Global.randChance(20):
		Global.battleScene.rules.burnoutAmount += 1
