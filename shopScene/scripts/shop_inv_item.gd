extends Control

@export var type: Type
@export var slotIndex: int
enum Type { ASTEROID, STAR }
var item: set = changeItem
var grabbed = false
var inRange = false
var empty = false


func changeItem(newItem):
	item = newItem
	if item == null:
		$Sprite.visible = false
		empty = true
	else:
		if type == Type.ASTEROID:
			$Sprite.texture = load("res://ART/asteroidArts/" + item + ".png")
			$Sprite.visible = true
			empty = false
		else:
			$Sprite.texture = load("res://ART/starArts/" + item + ".png")
			$Sprite.visible = true
			empty = false


func _process(delta):
	if grabbed:
		$Sprite.position = get_local_mouse_position()

func _input(event):
	
	if type == Type.STAR:
		return
	
	if Input.is_action_just_pressed("click") and inRange:
		grabbed = true
		Global.itemGrabbed = $"."
	
	if grabbed and !Input.is_action_pressed("click"):
		grabbed = false
		$Sprite.position = Vector2(0, 0)
		
		if Global.overSell:
			get_parent().get_parent().get_parent().money += Global.itemsToData[item][0]/2
			Global.asteroidPermStats[slotIndex] = [0,0]
			changeItem(null)
			
		
		call_deferred("clear_global_grab")

	if inRange and !grabbed and Global.itemGrabbed != null and !Input.is_action_pressed("click"):
		var temp = Global.itemGrabbed.item
		var tempStats = Global.asteroidPermStats[slotIndex]
		Global.asteroidPermStats[slotIndex] = Global.asteroidPermStats[Global.itemGrabbed.slotIndex]
		Global.asteroidPermStats[Global.itemGrabbed.slotIndex] = tempStats
		Global.itemGrabbed.item = item
		item = temp
		Global.itemGrabbed = null


func _on_control_mouse_entered():
	inRange = true


func _on_control_mouse_exited():
	inRange = false


func clear_global_grab():
	if Global.itemGrabbed == self:
		Global.itemGrabbed = null
