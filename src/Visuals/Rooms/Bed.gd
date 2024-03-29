extends Node2D


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$Label.show()
		$Sprite.frame = 1
		body.setTarget(Types.Target.NextWeek)

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$Label.hide()
		$Sprite.frame = 0
		body.unsetTarget()
