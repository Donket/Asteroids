extends Control

@export var type: Type
@export var slotIndex: int
enum Type { ASTEROID, STAR }
var item: set = changeItem
var grabbed = false
var inRange = false
var empty = false
var exp = 0: set = changeExp

var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")


func changeExp(newExp):
	exp = newExp
	Global.asteroidExps[slotIndex] = exp
	$TextureProgressBar.value = exp % 3


func changeItem(newItem):
	item = newItem
	if item == null:
		$Sprite.visible = false
		$TextureProgressBar.visible = false
		empty = true
	else:
		if type == Type.ASTEROID:
			$Sprite.texture = load("res://ART/asteroidArts/" + item + ".png")
			$Sprite.visible = true
			$TextureProgressBar.visible = true
			empty = false
		else:
			$Sprite.texture = load("res://ART/starArts/" + item + ".png")
			$Sprite.visible = true
			$TextureProgressBar.visible = false
			empty = false


func _process(delta):
	if grabbed:
		$Sprite.position = get_local_mouse_position()
		$TextureProgressBar.position = get_local_mouse_position() + Vector2(-54,-84)

func _input(event):
	
	var starSold = false
	
	if Input.is_action_just_pressed("click") and inRange:
		grabbed = true
		Global.itemGrabbed = $"."
	
	if grabbed and !Input.is_action_pressed("click"):
		Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
		grabbed = false
		$Sprite.position = Vector2(0, 0)
		$TextureProgressBar.position = Vector2(-54,-84)
		
		if Global.overSell:
			if type == Type.ASTEROID:
				get_parent().get_parent().get_parent().money += Global.itemsToData[item][0]/2
				Global.asteroidPermStats[slotIndex] = [0,0]
				changeItem(null)
			else:
				get_parent().get_parent().get_parent().money += Global.starsToData[item][0]/2
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
			print(exp)
			Global.itemGrabbed.item = null
			Global.itemGrabbed.exp = 0
			
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
	if empty == false and Global.itemGrabbed == null:
		Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_control_mouse_exited():
	inRange = false
	if empty == false and Global.itemGrabbed == null:
		Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func clear_global_grab():
	if Global.itemGrabbed == self:
		Global.itemGrabbed = null
