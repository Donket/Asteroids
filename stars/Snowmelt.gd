extends Node

var main

func onHit(asteroid):
	if main.rules.blockAmount >= 1:
		main.rules.blockAmount -= 1
		main.rules.burnoutAmount += 1
