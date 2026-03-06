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

static var hovered_slot = null 

func changeExp(newExp):
	exp = newExp
	Global.asteroidExps[slotIndex] = exp
	$visuals/TextureProgressBar.value = exp % 3
	if item != null:
		$visuals/RichTextLabel.text = "[center]LVL "+str(Global.getLevel(slotIndex))
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
		initTooltips()


func _process(delta):
	if grabbed:
		$visuals.position = get_local_mouse_position()

func _input(event):
	
	var starSold = false
	
	if Input.is_action_just_pressed("click") and inRange and !empty:
		invUi.clickSfx.playing = true
		grabbed = true
		Global.itemGrabbed = $"."
		if type == Type.ASTEROID:
			get_parent().get_parent().get_parent().get_node("SellButton").get_child(1).text = "[center]Sell (" + str(Global.itemsToData[item][0]/2) + ")"
		else:
			get_parent().get_parent().get_parent().get_node("SellButton").get_child(1).text = "[center]Sell (" + str(Global.starsToData[item][0]/2) + ")"
		$AnimationPlayer.play("close")
		open = false
	
	if grabbed and !Input.is_action_pressed("click"):
		if hovered_slot != null and hovered_slot != self and hovered_slot.type != Type.STAR:
			hovered_slot.receive_drop(self)

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
		get_parent().get_parent().update()

		if starSold:
			queue_free()

func receive_drop(source_item):
	if source_item.type == Type.STAR:
		return
	elif source_item.item == item:
		exp += source_item.exp + 1
		source_item.item = null
	else:
		var temp = source_item.item
		var tempStats = Global.asteroidPermStats[slotIndex]
		var tempExp = source_item.exp
		
		Global.asteroidPermStats[slotIndex] = Global.asteroidPermStats[source_item.slotIndex]
		Global.asteroidPermStats[source_item.slotIndex] = tempStats
		
		source_item.exp = exp
		source_item.item = item
		
		item = temp
		exp = tempExp
	get_parent().get_parent().update()

func _on_control_mouse_entered():
	inRange = true
	hovered_slot = self
	invUi.hoverSfx.playing = true
	if empty == false and Global.itemGrabbed == null:
		Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		$AnimationPlayer.play("open")
		open = true


func _on_control_mouse_exited():
	inRange = false
	if hovered_slot == self: hovered_slot = null
	if empty == false and Global.itemGrabbed == null:
		Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$AnimationPlayer.play("close")
		open = false


func clear_global_grab():
	if Global.itemGrabbed == self:
		Global.itemGrabbed = null
		get_parent().get_parent().get_parent().get_node("SellButton").get_child(1).text = "[center]Sell"
		if inRange and !open and empty == false:
			$AnimationPlayer.play("open")


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
