extends KinematicBody2D

const STOP_FORCE_FLOOR = 700
const WALK_FORCE = 1600
const MAX_SPEED = 120

var velocity = Vector2(0,0)

var target = null
var UI = null

func connectUI(node):
	UI = node

func _physics_process(delta):
	
	if UI.activeDisplay:
		return
	
	var inputDirection = getInputDirection()

	# Stop Movement
	if inputDirection.x == 0:
		var stopForce = delta * STOP_FORCE_FLOOR

		if velocity.x > 0:
			velocity.x = max(velocity.x - stopForce, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + stopForce, 0)
	# Accelarete
	else:
		velocity.x += inputDirection.x * delta * WALK_FORCE
		if velocity.x > MAX_SPEED:
			velocity.x = MAX_SPEED
		elif velocity.x < -MAX_SPEED:
			velocity.x = -MAX_SPEED

	velocity = move_and_slide(velocity, Vector2(0, -1))


	if target != null and Input.is_action_just_pressed("ui_up"):
		print("pressed")
		Global.GI.performAction(target)


func getInputDirection():
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input
	
	

func setTarget(trg):
	target = trg
	
func unsetTarget():
	target = null
