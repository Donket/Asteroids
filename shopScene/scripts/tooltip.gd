extends Control

var typeToDesc = {
	"res://ART/icons/parasiteIcon.png": 
		"[center][img]res://ART/icons/parasiteIcon.png[/img] (Parasite) has a chance of triggering every 0.2 seconds. If it successfully triggers, spawn a copy of the asteroid in your first slot directly behind the ship, shooting away from it.",
	"res://ART/icons/burnoutIcon.png": 
		"[center][img]res://ART/icons/burnoutIcon.png[/img] (Burnout) triggers every 5 seconds and deals 3 damage per stack. It also slows the ship and prevents it from shooting for 0.1 seconds times the number of stacks.",
	"res://ART/icons/moneyIcon.png": 
		"[center][img]res://ART/icons/moneyIcon.png[/img] (Money) is the currency used to purchase items in the shop.",
	"res://ART/icons/breachIcon.png": 
		"[center][img]res://ART/icons/breachIcon.png[/img] (Breach) triggers every second and deals 1% of the ship's current hp as damage per stack.",
	"res://ART/icons/blockIcon.png": 
		"
[center]Each time an asteroid would be shot, if you have [img]res://ART/icons/blockIcon.png[/img] (Block) instead use a stack to prevent the asteroid from being destroyed.",
	"res://ART/icons/bounceIcon.png": 
		"
[center]When an asteroid hits a wall, if it has [img]res://ART/icons/bounceIcon.png[/img] (Bounce) it uses a stack to ricochet off the wall and not be destroyed.",
	"res://ART/icons/spawnIcon.png": 
		"[center][img]res://ART/icons/spawnIcon.png[/img] (Spawn), which is triggered by certain abilities, spawns an asteroid or set of asteroids in the location of the asteroid that spawned them (unless otherwise specified).",
}

var type: set = changeType

func changeType(new):
	type = new
	$RichTextLabel.text = typeToDesc[new]
