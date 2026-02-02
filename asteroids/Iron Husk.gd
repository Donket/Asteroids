extends Node2D

var launcher
var main

var baseSpeed = 120
var baseAcceleration = 0
var bounces = 0

var damage = 40

func onSpawn():
	bounces = Global.getLevel(launcher.index)


