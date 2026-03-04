extends Control

@export var index: int

var time = 1
var max_time = 1
var texture: set = changeText
var open = false
var empty = true
var item = null: set = setItem

func changeText(newTexture):
	texture = newTexture
	$Sprite2D2.texture = newTexture

func _process(delta):
	if $ProgressBar.max_value != max_time*100:
		$ProgressBar.max_value = max_time*100
	$ProgressBar.value = time*100


func _on_progress_bar_mouse_entered():
	open = true
	if empty == false:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		$AnimationPlayer.play("open")


func _on_progress_bar_mouse_exited():
	open = false
	if empty == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$AnimationPlayer.play("close")

func setItem(newItem):
	item = newItem
	if item == null:
		empty = true
	else:
		$panel/RichTextLabel.text = "[center]"+item
		$panel/RichTextLabel2.text = Global.getDesc(item,Global.getLevel(index))
		$panel/spdLabel.text = "[center]"+str(Global.itemsToData[item][2]+Global.asteroidPermStats[index][0])
		$panel/dmgLabel.text = "[center]"+str(Global.itemsToData[item][3]+Global.asteroidPermStats[index][1])
		empty = false
	initTooltips()



func initTooltips():
	var container = $panel/GridContainer
	for tt in container.get_children():
		tt.free()
	container.position.y = -50
	var tooltips = ["res://ART/icons/parasiteIcon.png", "res://ART/icons/burnoutIcon.png", "res://ART/icons/moneyIcon.png", "res://ART/icons/breachIcon.png", "res://ART/icons/blockIcon.png", "res://ART/icons/bounceIcon.png", "res://ART/icons/spawnIcon.png"]
	if position.x == -710:
		container.position.x = 290
	for tt in tooltips:
		if tt in $panel/RichTextLabel2.text:
			var scene = load("res://shopScene/scenes/tooltip.tscn").instantiate()
			scene.type = tt
			container.add_child(scene)
	container.position.y -= 90*(container.get_child_count()-1)
