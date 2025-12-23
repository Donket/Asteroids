extends Node2D




var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 0

var damage = 20


func onCrash():
	var arr = []
	for child in Global.itemsToData.keys():
		if "Relic" in child and child != "Ancient Relic":
			arr.append(child)
	main.spawn(self, arr.pick_random())

