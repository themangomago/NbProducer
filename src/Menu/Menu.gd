extends Control

enum MenuState {Main, Settings}

func _ready():
	Global.setMenu(self)
	$Version.bbcode_text = "[right]"+ Global.getVersionString() + "[/right]"
	stateTransition(MenuState.Main)

func _on_ButtonExit_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		print("Ok, Bye! Thanks for playing.")
		get_tree().quit()


func _on_ButtonSettings_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		stateTransition(MenuState.Settings)

func _on_ButtonPlay_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		Global.getGameManager().newGame()

func stateTransition(to):
	if to == MenuState.Main:
		$Settings.hide()
		$Main.show()
	elif to == MenuState.Settings:
		updateSettings()
		$Settings.show()
		$Main.hide()

func updateSettings():
	var lights = Global.getGameManager().getLights()

	if Global.userConfig.fullscreen:
		$Settings/ButtonFullscreen/Text.bbcode_text = "[center]Fullscreen: On[/center]"
	else:
		$Settings/ButtonFullscreen/Text.bbcode_text = "[center]Fullscreen: Off[/center]"

func _on_ButtonBack_button_up():
	stateTransition(MenuState.Main)


func _on_ButtonFullscreen_button_up():
	Global.fullscreen()
	updateSettings()
	
