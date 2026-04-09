extends Node

var main

func onBounce(asteroid):
	main.rules.burnoutAmount += ceil(asteroid.attributes.damage * 0.01)
	asteroid.attributes.damage = 0
