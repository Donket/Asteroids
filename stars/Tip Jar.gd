extends Node

var main

func onHit(asteroid):
	if Global.randChance(10):
		main.money += 1
