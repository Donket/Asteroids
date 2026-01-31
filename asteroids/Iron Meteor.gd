extends Node2D


var launcher
var main

var baseSpeed = 210
var baseAcceleration = 0
var bounces = 0

var damage = 205



func onHit():
	var level = Global.getLevel(launcher.index)
	var arr = []
	for child in Global.itemsToData.keys():
		if "Iron" in child and child != "Iron Meteor":
			arr.append(child)
	for i in level:
		main.spawn(self, arr.pick_random())
		main.spawn(self, arr.pick_random())

