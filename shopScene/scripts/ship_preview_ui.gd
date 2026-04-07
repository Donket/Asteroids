extends Control

var maxHP = 500
var phase = 1
var turn = 0


func _ready():
	getPhase()
	turn = Global.turn+1
	maxHP *= pow(1.15,turn)
	$Sprite2D/RichTextLabel.text += str(round(maxHP))
	var count = max(0,floor((turn+1)/2)-1)
	if count > 1:
		$Sprite2D/CenterContainer/RichTextLabel2.text += "Shoots " + str(count) + " bullets at once."
	if phase == 1:
		$Sprite2D/CenterContainer/RichTextLabel2.text += "Fires at all asteroids every 5 secs."
		$Sprite2D/Sprite2D2.animation = "ship2"
	if phase == 2:
		$Sprite2D/CenterContainer/RichTextLabel2.text += "Cannot take more than 20 damage at once. Moves slowly."
		$Sprite2D/Sprite2D2.animation = "ship3"
	if phase == 3:
		$Sprite2D/CenterContainer/RichTextLabel2.text += "???"
		$Sprite2D/Sprite2D2.animation = "boss"
		$Sprite2D/Sprite2D2.scale = Vector2(0.9,0.9)

func getPhase():
	for i in range(10):
		phase = floor(Global.wins/3)


func _on_rich_text_label_mouse_entered():
	$Sprite2D/CenterContainer.visible = true
	


func _on_rich_text_label_mouse_exited():
	$Sprite2D/CenterContainer.visible = false
