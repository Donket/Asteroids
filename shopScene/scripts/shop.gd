extends Node2D

var items = []
var invOpen = false
var money = 0: set = setMoney

func _ready():
	for i in range(5):
		var scene = load("res://shop_item.tscn").instantiate()
		items.append(scene)
		scene.position = $anchors.get_child(i).position
		scene.type = 0
		$items.add_child(scene)
	for i in range(2):
		var scene = load("res://shop_item.tscn").instantiate()
		items.append(scene)
		scene.position = $anchors.get_child(i+5).position
		scene.type = 1
		$items.add_child(scene)
	money = Global.money


func _on_roll_button_pressed():
	if money < 5:
		return
	for item in items:
		item.randomizeItem()
	money -= 5

func _input(event):
	if Input.is_action_just_pressed("e") and !invOpen:
		$AnimationPlayer.play("openInv")
		invOpen = true
		$shopInvUI.refresh()
	if Input.is_action_just_pressed("back") and invOpen:
		$AnimationPlayer.play("closeInv")
		invOpen = false
		$shopInvUI.update()

func _on_end_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_control_mouse_entered():
	Global.overSell = true


func _process(delta):
	print(Global.asteroidPermStats)

func _on_control_mouse_exited():
	Global.overSell = false

func setMoney(newMoney):
	$RichTextLabel.text = "[center] [img]res://ART/icons/moneyIcon.png[/img]" + str(newMoney)
	money = newMoney
	Global.money = newMoney
