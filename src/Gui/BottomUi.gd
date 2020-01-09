extends Control


func setInfo(week, money, action):
	$LWeek.set_text("Week " + str(week))
	$LMoney.set_text("$"+str(money))
	$LAction.set_text("Action Points: " + str(action))
