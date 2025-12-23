extends Node2D




	#"Iron Husk": 
#"Has: 1 [img]res://bounceIcon.png[/img]",
#
	#"Iron Rock": 
#"On Crash: [img]res://spawnIcon.png[/img] Iron Husk (25% chance)",
#
	#"Iron Gem": 
#"On Hit: Apply 1 [img]res://breachIcon.png[/img]",
#
	#"Iron Relic": 
#"On Bounce: Gain Acceleration
#
#Has: 1 [img]res://bounceIcon.png[/img]",
#
	#"Iron Meteor": 
#"On Hit: [img]res://spawnIcon.png[/img] 2 random Rocks",
#


var launcher
var main

var baseSpeed = 300
var baseAcceleration = 0
var bounces = 1

var damage = 25



func onBounce():
	get_parent().acceleration += 50

