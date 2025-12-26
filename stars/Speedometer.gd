extends Node

var main

var timeElapsed = 0

func _process(delta):
	timeElapsed += delta
	if timeElapsed >= 1:
		timeElapsed = 0
		var average = 0
		for asteroid in main.asteroids:
			if !asteroid:
				continue
			average += asteroid.speed
		if average != 0:
			average /= main.asteroids.size()
		main.money += round(0.1 * average)
