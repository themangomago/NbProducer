extends Node2D


func _ready():
	$StairWayCellar/Label.hide()
	$StairWayUpper/Label.hide()

func _on_StairWayCellar_body_entered(body):
	if body.is_in_group("player"):
		$StairWayCellar/Label.show()
		$StairWayCellar/Sprite.frame = 1
		body.setTarget(Types.Target.GoUp)

func _on_StairWayCellar_body_exited(body):
	if body.is_in_group("player"):
		$StairWayCellar/Label.hide()
		$StairWayCellar/Sprite.frame = 0
		body.unsetTarget(Types.Target.GoUp)

func _on_StairWayUpper_body_entered(body):
	if body.is_in_group("player"):
		$StairWayUpper/Label.show()
		$StairWayUpper/Sprite.frame = 1
		body.setTarget(Types.Target.GoDown)

func _on_StairWayUpper_body_exited(body):
	if body.is_in_group("player"):
		$StairWayUpper/Label.hide()
		$StairWayUpper/Sprite.frame = 0
		body.unsetTarget(Types.Target.GoDown)
