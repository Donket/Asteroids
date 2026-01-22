extends Control

var open = false

func _on_button_pressed():
	if !open:
		open = true
		$AnimationPlayer.play("open")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if Input.is_action_just_pressed("back") and open:
		$AnimationPlayer.play("close")
		open=false
