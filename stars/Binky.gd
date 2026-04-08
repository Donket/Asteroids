extends Node2D

var main

func onBounce(asteroid):
	if Global.randChance(20):
		main.rules.breachAmount += 1
