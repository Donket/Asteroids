extends Node2D


var defaultCursor = preload("res://ART/uiArts/cursor.png")
var hoverCursor = preload("res://ART/uiArts/cursorSelect.png")


func _ready():
	Engine.time_scale = 1
	if Global.wins >= Global.maxWins:
		$VerdictLabel.text = "Victory!"
	else:
		$VerdictLabel.text = "Defeat..."
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://shopScene/scenes/shop.tscn")


func _on_play_again_button_mouse_entered():
	$playAgainLabel.text = "[center][color=yellow]Play Again"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))



func _on_play_again_button_mouse_exited():
	$playAgainLabel.text = "[center]Play Again"
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_exit_button_pressed():
	get_tree().quit()


func _on_exit_button_mouse_entered():
	$exitLabel.text = "[center][color=yellow]Exit"
	Input.set_custom_mouse_cursor(hoverCursor, Input.CURSOR_ARROW, Vector2(36, 21))


func _on_exit_button_mouse_exited():
	$exitLabel.text = "[center]Exit"
	Input.set_custom_mouse_cursor(defaultCursor, Input.CURSOR_ARROW, Vector2(36, 21))
