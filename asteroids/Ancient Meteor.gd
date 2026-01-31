extends Node2D



var launcher
var main

var baseSpeed = 230
var baseAcceleration = 0
var bounces = 0

var damage = 210


func onHit():
	var level = Global.getLevel(launcher.index)
	var arr = []
	for child in Global.itemsToData.keys():
		if "Ancient" in child and child != "Ancient Meteor":
			arr.append(child)
	for i in range(Global.getLevel(launcher.index)):
		main.spawn(self, arr.pick_random())
		main.spawn(self, arr.pick_random())
		main.spawn(self, arr.pick_random())

