extends Node

var main

func onBounce(asteroid):
	main.rules.hp -= asteroid.attributes.damage*0.05
	Global.addToLog("Sandpaper", asteroid.attributes.damage*0.05)
