extends Node

var main

var timeElapsed = 0

func _process(delta):
	timeElapsed += delta
	if timeElapsed >= 1:
		timeElapsed = 0
		if main.rules.burnoutAmount + main.rules.blockAmount + main.rules.breachAmount + main.rules.parasiteAmount >= 30:
			main.rules.burnoutAmount = 0
			main.rules.blockAmount = 0 
			main.rules.breachAmount = 0
			main.rules.parasiteAmount = 0
			for asteroid in main.asteroids:
				asteroid.damage += 50
