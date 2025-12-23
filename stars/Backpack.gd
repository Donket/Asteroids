extends Node

var main

func onSpawn(asteroid):
	var num = main.get_node("rules").get_child_count()
	asteroid.speed *= (1+num*0.01)
