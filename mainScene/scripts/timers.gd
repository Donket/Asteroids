extends Node2D

@onready var parent = $".."


func _on_timer_timeout():
	parent.timeout(0)


func _on_timer_2_timeout():
	parent.timeout(1)


func _on_timer_3_timeout():
	parent.timeout(2)


func _on_timer_4_timeout():
	parent.timeout(3)


func _on_timer_5_timeout():
	parent.timeout(4)


func _on_timer_6_timeout():
	parent.timeout(5)
