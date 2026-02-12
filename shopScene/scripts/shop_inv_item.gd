extends Control

@export var type: Type
@export var slotIndex: int
enum Type { ASTEROID, STAR }
var item: set = changeItem
var grabbed = false
var inRange = false
var empty = false
var exp = 0: set = changeExp
var open = false
@onready var invUi = get_parent().get_parent()

var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")


func changeExp(newExp):
	exp = newExp
	Global.asteroidExps[slotIndex] = exp
	$visuals/TextureProgressBar.value = exp % 3
	if item != null:
		$visuals/RichTextLabel.text = "[center]"+str(Global.getLevel(slotIndex))
		$panel/RichTextLabel2.text = Global.getDesc(item,Global.getLevel(slotIndex))
	else:
		$visuals/RichTextLabel.text = ""

func changeItem(newItem):
	var sprite = $visuals/Sprite
	item = newItem
	if item == null:
		exp = 0
		sprite.visible = false
		$visuals/TextureProgressBar.visible = false
		empty = true
	else:
		if type == Type.ASTEROID:
			sprite.texture = load("res://ART/asteroidArts/" + item + ".png")
			$panel/RichTextLabel.text = "[center]"+item
			$panel/RichTextLabel2.text = Global.getDesc(item,Global.getLevel(slotIndex))
			$panel/spdLabel.text = "[center]"+str(Global.itemsToData[item][2]+Global.asteroidPermStats[slotIndex][0])
			$panel/dmgLabel.text = "[center]"+str(Global.itemsToData[item][3]+Global.asteroidPermStats[slotIndex][1])
			sprite.visible = true
			$visuals/TextureProgressBar.visible = true
			empty = false
		else:
			sprite.texture = load("res://ART/starArts/" + item + ".png")
			$panel/RichTextLabel.text = "[center]"+item
			$panel/RichTextLabel2.text = Global.itemsToDesc[item]
			$panel/RichTextLabel5.visible = false
			$panel/RichTextLabel6.visible = false
			$panel/Sprite2D.texture = load("res://ART/uiArts/starShopPanel.png")
			sprite.visible = true
			$visuals/TextureProgressBar.visible = false
			$visuals/RichTextLabel.visible = false
			empty = false


func _process(delta):
	if grabbed:
		$visuals.position = get_local_mouse_position()

func _input(event):
	
	var starSold = false
	
	if Input.is_action_just_pressed("click") and inRange:
		invUi.clickSfx.playing = true
		grabbed = true
		Global.itemGrabbed = $"."
		$AnimationPlayer.play("close")
		open = false
	
	if grabbed and !Input.is_action_pressed("click"):
		Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
		grabbed = false
		$visuals.position = Vector2(0, 0)
		
		if Global.overSell:
			invUi.sellSfx.playing = true
			if type == Type.ASTEROID:
				invUi.get_parent().money += Global.itemsToData[item][0]/2
				Global.asteroidPermStats[slotIndex] = [0,0]
				changeItem(null)
			else:
				invUi.get_parent().money += Global.starsToData[item][0]/2
				starSold = true
				
		
		call_deferred("clear_global_grab")
		
		
		var viewport = get_viewport()
		var globalPos = viewport.get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.warp_mouse(Vector2(9999, 9999))
		await get_tree().process_frame
		await get_tree().process_frame
		Input.warp_mouse(globalPos)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		if starSold:
			queue_free()

	if inRange and !grabbed and Global.itemGrabbed != null and !Input.is_action_pressed("click") and type != Type.STAR:
		if Global.itemGrabbed.item == item:
			exp += Global.itemGrabbed.exp+1
			Global.itemGrabbed.item = null
			
		else:
			var temp = Global.itemGrabbed.item
			var tempStats = Global.asteroidPermStats[slotIndex]
			var tempExp = Global.itemGrabbed.exp
			Global.asteroidPermStats[slotIndex] = Global.asteroidPermStats[Global.itemGrabbed.slotIndex]
			Global.asteroidPermStats[Global.itemGrabbed.slotIndex] = tempStats
			Global.itemGrabbed.exp = exp
			Global.itemGrabbed.item = item
			item = temp
			exp = tempExp
			Global.itemGrabbed = null




func _on_control_mouse_entered():
	inRange = true
	invUi.hoverSfx.playing = true
	if empty == false and Global.itemGrabbed == null:
		Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		$AnimationPlayer.play("open")
		open = true


func _on_control_mouse_exited():
	inRange = false
	if empty == false and Global.itemGrabbed == null:
		Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$AnimationPlayer.play("close")
		open = false


func clear_global_grab():
	if Global.itemGrabbed == self:
		Global.itemGrabbed = null
		if inRange and !open:
			$AnimationPlayer.play("open")
