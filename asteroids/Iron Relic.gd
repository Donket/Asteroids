extends Node2D




var launcher
var main

var baseSpeed = 160
var baseAcceleration = 0
var bounces = 0

var damage = 165

func onSpawn():
	var level = Global.getLevel(launcher.index)
	bounces = level

func onBounce():
	get_parent().acceleration += 50

