extends Node2D

var launcher
var main

var baseSpeed = 110
var baseAcceleration = 0
var bounces = 0

var damage = 80



func onCrash():
	var level = Global.getLevel(launcher.index)
	for i in 1+level*2:
		main.spawn(self, "Iron Husk")

