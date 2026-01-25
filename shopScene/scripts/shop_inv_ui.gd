extends Control

func _ready():
	refresh()



func refresh():
	var iter = 0
	for child in $GridContainer.get_children():
		if iter < Global.asteroidsDeck.size():
			child.item = Global.asteroidsDeck[iter]
			child.exp = Global.asteroidExps[iter]
			iter += 1
	
	var startInd = $GridContainer2.get_child_count()
	while Global.starsDeck.size() > $GridContainer2.get_child_count():
		var scene = load("res://shopScene/scenes/shop_inv_item.tscn").instantiate()
		scene.type = 1
		scene.item = Global.starsDeck[startInd]
		$GridContainer2.add_child(scene)
		startInd += 1
		
	$GridContainer2.add_theme_constant_override("separation", 1000.0 / (Global.starsDeck.size() + 1))
	$GridContainer2.hide()
	$GridContainer2.show()

	

func update():
	var iter = 0
	for child in $GridContainer.get_children():
		Global.asteroidsDeck[iter] = child.item
		iter += 1
	var arr = []
	for child in $GridContainer2.get_children():
		arr.append(child.item)
	Global.starsDeck = arr
