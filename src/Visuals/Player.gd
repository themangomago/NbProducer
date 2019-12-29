extends KinematicBody2D

const STOP_FORCE_FLOOR = 700
const WALK_FORCE = 1600
const MAX_SPEED = 160

var velocity = Vector2(0,0)

var target = null
var UI = null

enum AnimState {Idle, Walk}

var animState = null


func connectUI(node):
	UI = node

func _ready():
	processAnimState(AnimState.Idle)

func _physics_process(delta):
	if get_parent().get_parent().lockPlayer:
		return
	
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
		elif velocity.x == 0:
			processAnimState(AnimState.Idle)
	# Accelarete
	else:
		velocity.x += inputDirection.x * delta * WALK_FORCE
		if velocity.x > MAX_SPEED:
			velocity.x = MAX_SPEED
			direction(Types.Direction.Right)
		elif velocity.x < -MAX_SPEED:
			velocity.x = -MAX_SPEED
			direction(Types.Direction.Left)
		processAnimState(AnimState.Walk)
	velocity = move_and_slide(velocity, Vector2(0, -1))


	if target != null and Input.is_action_just_pressed("ui_up"):
		Global.GI.performAction(target)
		processAnimState(AnimState.Idle)

func direction(dir):
	if dir == Types.Direction.Left:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func processAnimState(anim):
	match anim:
		AnimState.Idle:
			if animState != AnimState.Idle:
				animState = AnimState.Idle
				$AnimationPlayer.play("idle")
		AnimState.Walk:
			if animState != AnimState.Walk:
				animState = AnimState.Walk
				$AnimationPlayer.play("walk")
			


func getInputDirection():
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input
	
	

func setTarget(trg):
	target = trg
	
func unsetTarget(check = null):
	if check:
		if target == check:
			target = null
	else:
		target = null
