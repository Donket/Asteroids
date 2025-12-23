extends Node

var main

func onHit(asteroid):
	if asteroid.get_node("attributes").has_method("onHit"):
		asteroid.get_node("attributes").onHit()
