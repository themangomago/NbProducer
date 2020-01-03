extends Control

var backlog = []

func notify(string):
	if $AnimationPlayer.is_playing():
		backlog.append(string)
		return
	_start(string)

func _start(string):
	$Label.set_text(string)
	$AnimationPlayer.play("pop")


func _on_AnimationPlayer_animation_finished(anim_name):
	if backlog.size() > 0:
		_start(backlog[0])
		backlog.pop_front()
