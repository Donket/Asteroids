extends Node

var main

func onCrash(asteroid):
	if randf_range(0,1) <= 0.2:
		main.get_node("rules").hp -= asteroid.attributes.damage

