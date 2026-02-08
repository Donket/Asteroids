extends Node

var launcher
var main

var baseSpeed = 90
var baseAcceleration = 0
var bounces = 0

var damage = 50



func onBounce():
	var level = Global.getLevel(launcher.index)
	Global.block += level
