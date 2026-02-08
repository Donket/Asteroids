extends Node

var launcher
var main

var baseSpeed = 160
var baseAcceleration = 0
var bounces = 0

var damage = 90



func onHit():
	var level = Global.getLevel(launcher.index)
	var asteroid = get_parent()
	var block = Global.block
	asteroid.speed *= (1+block/200) * level
	asteroid.seekRadius *= (1+block/200) * level
	asteroid.turnSpeed *= (1+block/200) * level
	asteroid.attributes.damage *= (1+block/200) * level
	asteroid.attributes.bounces *= (1+block/200) * level
