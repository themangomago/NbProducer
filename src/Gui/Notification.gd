extends Control

var backlog = []

func notify(string, origin):
	if $AnimationPlayer.is_playing():
		backlog.append(string)
		return
	_start(string)

func notifySilent(string, origin):
	print("Silent:" + origin + ":" + string)
	pass
	#TODO history log

func warn(string):
	print("Warn: " + str(string))

func _start(string):
	$Label.set_text(string)
	$AnimationPlayer.play("pop")


func _on_AnimationPlayer_animation_finished(anim_name):
	if backlog.size() > 0:
		_start(backlog[0])
		backlog.pop_front()
