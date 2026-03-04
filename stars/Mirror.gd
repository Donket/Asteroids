extends Node

var main

func onBounce(asteroid):
	main.rules.hp -= asteroid.attributes.damage * 0.2
