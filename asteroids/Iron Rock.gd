extends Node2D

var launcher
var main

var baseSpeed = 110
var baseAcceleration = 0
var bounces = 0

var damage = 80



func onCrash():
	main.spawn(self, "Iron Husk")

