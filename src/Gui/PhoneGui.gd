extends Control




func prepareBank():
	var balanceNode = Global.GI.Balance
	var totalCredit = 0
	
	$PBank/LCash.set_text("Balance: "+str(balanceNode.cash))
	
	$PBank/THistory.text = "History\n"
	for credit in balanceNode.credits:
		var total = credit.amount * (1 + credit.rate / 100)
		var payRate = total / 24
		var remaining = min(0, total - (Global.GI.Week.week - credit.week) * payRate )
		
		$PBank/THistory.text += "Loan: $" + str(credit.amount) + \
			"Rate: " + str(credit.rate) + "% " + \
			"(Total: $" + str(total) + ")" + \
			"Outstanding: $" + str(remaining)
			

func clear():
	$PBank.hide()

func _on_BtnBank_button_up():
	clear()
	prepareBank()
	$PBank.show()
