extends Node2D

var launcher
var main

var baseSpeed = 210
var baseAcceleration = 0
var bounces = 0

var damage = 180


func onHit():
	var arr = []
	for child in Global.itemsToData.keys():
		if "Rock" in child:
			arr.append(child)
	for i in range(4):
		var inst = main.spawn(self, arr.pick_random())
		if Global.randChance(50):
			inst.die()
