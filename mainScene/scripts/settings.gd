extends Node2D


var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")


func _ready():
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_resume_button_mouse_entered():
	$resumeLabel.text = "[center][color=yellow]Resume"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_resume_button_mouse_exited():
	$resumeLabel.text = "[center]Resume"
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))
	

func _on_resume_button_pressed():
	visible = false


func _on_h_slider_mouse_entered():
	$volumeLabel.text = "[center][color=yellow]Volume"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_h_slider_mouse_exited():
	$volumeLabel.text = "[center]Volume"
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_menu_button_mouse_entered():
	$menuLabel.text = "[center][color=yellow]Main Menu"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_menu_button_mouse_exited():
	$menuLabel.text = "[center]Main Menu"
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_exit_button_mouse_entered():
	$exitLabel.text = "[center][color=yellow]Exit"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_exit_button_mouse_exited():
	$exitLabel.text = "[center]Exit"
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(24, 21))


func _on_menu_button_pressed():
	if get_parent().name == "mainMenu":
		visible = false
	else:
		get_tree().change_scene_to_file("res://startup/scenes/startupMenu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_h_slider_value_changed(value):
	if value == 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -100)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value-50)
