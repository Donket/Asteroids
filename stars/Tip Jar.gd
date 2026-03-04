extends Node

var main

func onHit(asteroid):
	if Global.randChance(40):
		main.money += 6
