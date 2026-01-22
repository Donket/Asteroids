extends Node2D

@onready var label = $mainLabel
var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")


var subtitles = [
	"Demo Out Soon!",
	"Demo Out Soon!",
	"Demo Out Soon!",
	"Demo Out Soon!",
	"Demo Out Soon!",
	"Very Original Title Screen!",
	"Egotistical Developer!",
	"Thousands of Bugs!",
	"Minimal Tutorial!",
	"Idiots Read This!",
	"A Moose Bit My Sister Once ...",
	"Mynd you, moose bites Kan be pretti nasti ...",
	"The Cake is a Lie!",
	"It’s Dangerous to go Alone!",
	"Birdhouse in Your Soul!"
]

func _ready():
	$subtitleLabel.text = "[center]" + subtitles.pick_random()
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_button_pressed():
	get_tree().change_scene_to_file("res://shopScene/scenes/shop.tscn")


func _on_button_2_pressed():
	$settingsLabel.visible = true


func _on_button_3_pressed():
	get_tree().quit()


func playHover():
	label.text = "[center][color=yellow]Play[/color]

Settings

Exit"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))
	
	


func settingsHover():
	label.text = "[center]Play

[color=yellow]Settings[/color]

Exit"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func exitHover():
	label.text = "[center]Play

Settings

[color=yellow]Exit[/color]"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func endHover():
	label.text = "[center]Play

Settings

Exit"
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
