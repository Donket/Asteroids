extends Node

var main

func onCrash(asteroid):
	Global.block += ceil(asteroid.speed * 0.01)
