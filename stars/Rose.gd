extends Node

var main

var timeElapsed = 0

func _process(delta):
	timeElapsed += delta
	if timeElapsed >= 4:
		main.onSpawn(main.asteroids.pick_random())
