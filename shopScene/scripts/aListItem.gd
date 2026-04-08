extends Control

@export var type: Type
enum Type { ASTEROID, STAR }

var cost: int = 0
var item: String = "": set = change
var currentBaseRarity: int = 0

@onready var hoverSfx = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("hover")

var itemsToDesc


func change(newItem: String):
	if newItem.is_empty():
		$Node2D.visible = false
		$Control.visible = false
		$RichTextLabel.visible = false
		$RichTextLabel2.visible = false
		item = newItem
	else:
		$Node2D.visible = true
		$Control.visible = true
		$RichTextLabel.visible = true
		item = newItem
		updateData()

func getItemProbability(targetItem, itemType, baseRarity):
	var items
	var dataArr
	if itemType == Type.ASTEROID:
		items = Global.itemsToData.keys()
		dataArr = Global.itemsToData
	else:
		items = Global.starsToData.keys()
		dataArr = Global.starsToData
	
	if not dataArr.has(targetItem):
		return 0.0
		
	var targetRarity = dataArr[targetItem][1]
	var rarityProb = 0.0
	
	if targetRarity == baseRarity:
		rarityProb += 0.5
		if baseRarity == 0:
			rarityProb += 0.4
			
		var max_rarity = 0
		for data in Global.itemsToData.values():
			max_rarity = max(max_rarity, data[1])
			
		if baseRarity >= max_rarity:
			rarityProb += 0.1
			
	elif targetRarity < baseRarity:
		rarityProb = 0.4 / baseRarity
		
	elif targetRarity == baseRarity + 1:
		rarityProb = 0.1

	var possible_items = []
	for i in items:
		if dataArr[i][1] == targetRarity:
			possible_items.append(i)
	
	if possible_items.is_empty() or rarityProb == 0:
		return 0.0
		
	var percentage = round((rarityProb / possible_items.size()) * 10000.0)/100
	return percentage


func updateData():
	var dataArr
	if type == Type.ASTEROID:
		dataArr = Global.itemsToData
	else:
		dataArr = Global.starsToData
	cost = dataArr[item][0]
	var chance = getItemProbability(item, type, min(3,floor(Global.turn/2)))
	$Control/RichTextLabel.text = "[center]" + item
	if type == Type.ASTEROID:
		$Control/RichTextLabel2.text = Global.getDesc(item,1)
		$RichTextLabel.text = "[center]" + str(cost)
		$RichTextLabel2.text = "[center] "+str(chance)+"%"
		$Node2D.texture = load("res://ART/asteroidArts/" + item + ".png")
		$Control/spdLabel.text = "[center]"+str(Global.itemsToData[item][2])
		$Control/dmgLabel.text = "[center]"+str(Global.itemsToData[item][3])
	else:
		$Control/RichTextLabel2.text = Global.itemsToDesc[item]
		$RichTextLabel.text = "[center]" + str(cost)
		$RichTextLabel2.text = "[center] "+str(chance)+"%"
		$Node2D.texture = load("res://ART/starArts/" + item + ".png")
	initTooltips()


func _ready():
	currentBaseRarity = min(3,floor(Global.turn/2))
	if type == Type.STAR:
		$Control/Sprite2D.texture = load("res://ART/uiArts/starShopPanel.png")
		$Node2D.scale = Vector2(4,4)
		$Control/dmgLabel.visible = false
		$Control/spdLabel.visible = false
		$Control/RichTextLabel5.visible = false
		$Control/RichTextLabel6.visible = false

func _on_control_2_mouse_entered():
	if item == "":
		return
	hoverSfx.playing=true
	$AnimationPlayer.play("open")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



func _on_control_2_mouse_exited():
	if item == "":
		return
	$AnimationPlayer.play("close")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func initTooltips():
	var container = $Control/GridContainer
	for tt in container.get_children():
		tt.free()
	container.position.y = -50
	var tooltips = ["res://ART/icons/parasiteIcon.png", "res://ART/icons/burnoutIcon.png", "res://ART/icons/moneyIcon.png", "res://ART/icons/breachIcon.png", "res://ART/icons/blockIcon.png", "res://ART/icons/bounceIcon.png", "res://ART/icons/spawnIcon.png"]
	if position.x == -710:
		container.position.x = 290
	for tt in tooltips:
		if tt in $Control/RichTextLabel2.text:
			var scene = load("res://shopScene/scenes/tooltip.tscn").instantiate()
			scene.type = tt
			container.add_child(scene)
	container.position.y -= 90*(container.get_child_count()-1)

