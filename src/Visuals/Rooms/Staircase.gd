extends Node2D


func _ready():
	$StairWayCellar/Label.hide()
	$StairWayUpper/Label.hide()

func _on_StairWayCellar_body_entered(body):
	if body.is_in_group("player"):
		$StairWayCellar/Label.show()
		body.setTarget(Types.Target.GoUp)

func _on_StairWayCellar_body_exited(body):
	if body.is_in_group("player"):
		$StairWayCellar/Label.hide()
		body.unsetTarget()


func _on_StairWayUpper_body_entered(body):
	if body.is_in_group("player"):
		$StairWayUpper/Label.show()
		body.setTarget(Types.Target.GoDown)

func _on_StairWayUpper_body_exited(body):
	if body.is_in_group("player"):
		$StairWayUpper/Label.hide()
		body.unsetTarget()
