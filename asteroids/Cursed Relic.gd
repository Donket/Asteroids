extends Node2D

var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 1

var damage = 10


func onBounce():
	bounces += 1
	damage -= 3
