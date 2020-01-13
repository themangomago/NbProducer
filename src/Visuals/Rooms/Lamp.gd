extends Node2D


export(bool) var light = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if light:
		$Light2D.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
