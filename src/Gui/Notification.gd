extends Control

var backlog = []

func notify(string, origin):
	Global.GI.LogGui.addDiary(string, origin)
	if $AnimationPlayer.is_playing():
		backlog.append(string)
		return
	_start(string)

func warn(string):
	if $AnimationPlayer.is_playing():
		backlog.append(string)
		return
	_start(string)

func _start(string):
	$Label.bbcode_text = "\n[center]"+string+"[/center]"
	$AnimationPlayer.play("pop")

func _on_AnimationPlayer_animation_finished(anim_name):
	if backlog.size() > 0:
		_start(backlog[0])
		backlog.pop_front()
