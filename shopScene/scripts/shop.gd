extends Node2D

var items = []
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
	if Global.itemsSaved:
		await get_tree().process_frame
		rollPrice = Global.savedRollPrice
		for i in range(items.size()):
			items[i].item = Global.savedItems[i]
		Global.itemsSaved = false
	$RollButton/RichTextLabel.text = "[center]Roll (" + str(rollPrice) + ")"

func getItems():
	var ar = []
	for i in items:
		ar.append(i.item)
	return ar

func _on_roll_button_pressed():
	if money < floor(rollPrice):
		return
	for item in items:
		item.randomizeItem()
	money -= floor(rollPrice)
	rollPrice *= 1.3
	rollPrice = floor(rollPrice)
	$RollButton/RichTextLabel.text = "[center]Roll (" + str(rollPrice) + ")"


func _on_end_button_pressed():
	Global.shopTutorialComplete = true
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
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	$hover.playing = true
	


func _on_button_mouse_exited():
	$Button/Sprite2D.modulate = Color(1,1,1)
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_roll_button_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	$hover.playing = true


func _on_roll_button_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_end_button_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	$hover.playing = true


func _on_end_button_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_settings_button_mouse_entered():
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	$hover.playing = true


func _on_settings_button_mouse_exited():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_settings_button_pressed():
	$Settings.visible = true

func tutorialForce(asteroids, stars, inventoryv, sellv, rollv, previewv, tutorialv, endTurnv, refreshShop):
	await get_tree().process_frame
	$RollButton.visible = rollv
	$shipPreviewUI.visible = previewv
	$Button.visible = tutorialv
	$EndButton.visible = endTurnv
	$shopInvUI.visible = inventoryv
	$SellButton.visible = sellv
	if refreshShop:
		for i in range(5):
			items[i].item = asteroids[i]
		for i in range(2):
			items[i+5].item = stars[i]


func _on_a_list_button_mouse_entered():
	$aListButton/Sprite2D.modulate = Color(0.8,0.8,0.8)
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	$hover.playing = true


func _on_a_list_button_mouse_exited():
	$aListButton/Sprite2D.modulate = Color(1,1,1)
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_a_list_button_pressed():
	$aList.visible = true
