extends Node2D

var launcher
var main

var baseSpeed = 120
var baseAcceleration = 0
var bounces = 0

var damage = 80


func onCrash():
	if randf_range(0,1) > 0.5:
		var arr = []
		for child in Global.itemsToData.keys():
			if "Rock" in child:
				arr.append(child)
		main.spawn(self, arr.pick_random())
	else:
		Global.asteroidPermStats[launcher.index][0] += 5
