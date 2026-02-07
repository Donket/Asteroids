extends Node

var main

func onCrash(asteroid):
	if main.rules.burnoutAmount >= 2:
		Global.block += 3
		main.rules.burnoutAmount -= 3
