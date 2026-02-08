extends Node


var launcher
var main

var baseSpeed = 150
var baseAcceleration = 0
var bounces = 0

var damage = 70



func onHit():
	var level = Global.getLevel(launcher.index)
	Global.block += (main.rules.parasiteAmount + main.rules.burnoutAmount + main.rules.breachAmount)*(level+1)/2

