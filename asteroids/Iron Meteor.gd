extends Node2D


	#"Iron Meteor": 
#"On Hit: [img]res://spawnIcon.png[/img] 2 random Rocks",
#


var launcher
var main

var baseSpeed = 210
var baseAcceleration = 0
var bounces = 0

var damage = 205



func onHit():
	var arr = []
	for child in Global.itemsToData.keys():
		if "Iron" in child and child != "Iron Meteor":
			arr.append(child)
	main.spawn(self, arr.pick_random())
	main.spawn(self, arr.pick_random())

