extends Node2D




var launcher
var main

var baseSpeed = 200
var baseAcceleration = 0
var bounces = 0

var damage = 105


func onCrash():
	var level = Global.getLevel(launcher.index)
	var arr = []
	for child in Global.itemsToData.keys():
		if "Relic" in child and child != "Ancient Relic":
			arr.append(child)
	for i in range(Global.getLevel(launcher.index)):
		main.spawn(self, arr.pick_random())
		
