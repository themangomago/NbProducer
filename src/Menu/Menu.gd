extends Control

enum MenuState {Main, Settings}

func _ready():
	Global.setMenu(self)
	$Version.bbcode_text = "[right]"+ Global.getVersionString() + "[/right]"
	stateTransition(MenuState.Main)
	updateSettings()

func _on_ButtonExit_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		print("Ok, Bye! Thanks for playing.")
		get_tree().quit()


func _on_ButtonSettings_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		stateTransition(MenuState.Settings)
		Global.click()



func stateTransition(to):
	if to == MenuState.Main:
		$Settings.hide()
		$Main.show()
	elif to == MenuState.Settings:
		updateSettings()
		$Settings.show()
		$Main.hide()

func updateSettings():
	if Global.userConfig.music:
		$Settings/ButtonMusic/Text.bbcode_text = "[center]Music: On[/center]"
	else:
		$Settings/ButtonMusic/Text.bbcode_text = "[center]Music: Off[/center]"

	if Global.savegame != null:
		$Main/ButtonContinue.show()
	else:
		$Main/ButtonContinue.hide()

func _on_ButtonBack_button_up():
	stateTransition(MenuState.Main)
	Global.click()


func _on_ButtonFullscreen_button_up():
	Global.fullscreen()
	updateSettings()
	Global.click()
	

func _on_ButtonMusic_button_up():
	Global.toggleMusic()
	updateSettings()
	Global.click()

func _on_ButtonPlay_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		Global.getGameManager().newGame()
		Global.click()

func _on_ButtonContinue_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		Global.getGameManager().continueGame()
		Global.click()
