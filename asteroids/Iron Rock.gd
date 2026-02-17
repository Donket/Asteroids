extends Node2D

var launcher
var main

var baseSpeed = 110
var baseAcceleration = 0
var bounces = 0: set = changeBounce

var damage = 80



func onCrash():
	var level = Global.getLevel(launcher.index)
	for i in 1+level*2:
		main.spawn(self, "Iron Husk")


func changeBounce(newBounce):
	bounces = newBounce
	var n = Global.numOfStars("Iron Essence")
	if n > 0:
		get_parent().speed *= pow(1.1,n)
