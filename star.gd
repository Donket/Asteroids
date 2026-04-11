extends Control

var item = "": set = changeItem
var empty = true
var index = 0
var open = false

func bounce():
	$anims.play("bounce")


func changeItem(newItem):
	item = newItem
	$Sprite2D.visible = true
	$Sprite2D.texture = load("res://ART/starArts/" + newItem + ".png")
	$panel/RichTextLabel.text = "[center]"+item
	$panel/RichTextLabel2.text = Global.itemsToDesc[item]
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
	
	
func _on_control_mouse_entered():
	open = true
	if empty == false:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		$AnimationPlayer.play("open")


func _on_control_mouse_exited():
	open = false
	if empty == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$AnimationPlayer.play("close")
