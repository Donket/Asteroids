extends Node2D

var items = []
var invOpen = false
var money = 0: set = setMoney
var rollPrice = round(5 * pow(1.2,Global.numOfStars("Coupon Book")))
var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")

func _ready():
	Engine.time_scale = 1
	for i in range(5):
		var scene = load("res://shopScene/scenes/shop_item.tscn").instantiate()
		items.append(scene)
		scene.position = $anchors.get_child(i).position
		scene.type = 0
		$items.add_child(scene)
	for i in range(2):
		var scene = load("res://shopScene/scenes/shop_item.tscn").instantiate()
		items.append(scene)
		scene.position = $anchors.get_child(i+5).position
		scene.type = 1
		$items.add_child(scene)
	money = Global.money
	Global.turn += 1
	$RollButton/RichTextLabel.text = "[center]Roll (" + str(rollPrice) + ")"
	if Global.firstOpen:
		Global.firstOpen = false
		$tutorial.visible = true




func _on_roll_button_pressed():
	if money < floor(rollPrice):
		return
	for item in items:
		item.randomizeItem()
	money -= floor(rollPrice)
	rollPrice *= 1.3
	rollPrice = floor(rollPrice)
	$RollButton/RichTextLabel.text = "[center]Roll (" + str(rollPrice) + ")"

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
	get_tree().change_scene_to_file("res://mainScene/scenes/main.tscn")


func _on_control_mouse_entered():
	Global.overSell = true


func _on_control_mouse_exited():
	Global.overSell = false

func setMoney(newMoney):
	money = newMoney + Global.numOfStars("Golden Tooth")
	$RichTextLabel.text = "[center] [img]res://ART/icons/moneyIcon.png[/img]" + str(money)
	Global.money = money


func _on_button_pressed():
	$tutorial.visible = true


func _on_button_mouse_entered():
	$Button/Sprite2D.modulate = Color(0.8,0.8,0.8)
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))
	


func _on_button_mouse_exited():
	$Button/Sprite2D.modulate = Color(1,1,1)
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_roll_button_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_roll_button_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
	
	


func _on_end_button_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_end_button_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
