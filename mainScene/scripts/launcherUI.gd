extends Control

@export var index: int

var time = 1
var max_time = 1
var texture: set = changeText

func changeText(newTexture):
	texture = newTexture
	$Sprite2D2.texture = newTexture

func _process(delta):
	if $ProgressBar.max_value != max_time*100:
		$ProgressBar.max_value = max_time*100
	$ProgressBar.value = time*100
