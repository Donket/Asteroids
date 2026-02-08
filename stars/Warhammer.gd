extends Node

var main

func onHit(asteroid):
	main.rules.hp -= 3*(main.rules.burnoutAmount*main.rules.blockAmount*main.rules.breachAmount*main.rules.parasiteAmount)
