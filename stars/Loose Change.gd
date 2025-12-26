extends Node

var main

func onCrash(asteroid):
	if Global.randChance(30):
		main.money += 2
