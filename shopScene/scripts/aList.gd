extends Node2D

@onready var keys = Global.itemsToDesc.keys()
@onready var scene = preload("res://shopScene/scenes/aListItem.tscn")
@onready var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")


func _ready():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	for i in range(keys.size()):
		var s = scene.instantiate()
		if i < 25:
			s.type = 0
		else:
			s.type = 1
		s.item = keys[i]
		$ui/ScrollContainer/CenterContainer/GridContainer.add_child(s)
	for i in range(10):
		var s = scene.instantiate()
		s.type = 1
		s.item = ""
		$ui/ScrollContainer/CenterContainer/GridContainer.add_child(s)
	


func _on_button_pressed():
	visible = false


func _on_button_mouse_entered():
	$ui/Button/Sprite2D.modulate = Color(0.8,0.8,0.8)
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	$hover.playing = true


func _on_button_mouse_exited():
	$ui/Button/Sprite2D.modulate = Color(1,1,1)
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))
