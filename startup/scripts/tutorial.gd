extends Node2D

var ind = 1: set = playAnim
var numOfAnims = 3

func playAnim(newInd):
	ind = newInd
	$AnimationPlayer.play(str(ind))


func _on_button_pressed():
	ind = max(1,ind-1)


func _on_button_2_pressed():
	ind = min(numOfAnims,ind+1)

func _on_exit_button_pressed():
	self.visible = false


func _on_button_mouse_entered():
	$Button/Sprite2D.modulate = Color(0.8,0.8,0.8)


func _on_button_mouse_exited():
	$Button/Sprite2D.modulate = Color(1,1,1)
	
	
func _on_button_2_mouse_entered():
	$Button2/Sprite2D2.modulate = Color(0.8,0.8,0.8)


func _on_button_2_mouse_exited():
	$Button2/Sprite2D2.modulate = Color(1,1,1)


func _on_exit_button_mouse_entered():
	$Sprite2D.modulate = Color(0.8,0.8,0.8)


func _on_exit_button_mouse_exited():
	$Sprite2D.modulate = Color(1,1,1)


