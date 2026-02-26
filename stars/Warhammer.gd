extends Node

var main

func onHit(asteroid):
	var amt = 2*(main.rules.burnoutAmount+main.rules.blockAmount+main.rules.breachAmount+main.rules.parasiteAmount)
	main.rules.hp -= amt
	Global.addToLog("Warhammer", amt)
