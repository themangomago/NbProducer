extends Control


var credits = [{"amount": 10000, "rate": 5, "week": 0}]
var cash = 10000


var expenses = []
var revenues = []

var sheet = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addPositionExpenses(position, amount):
	var expe = int(amount)
	expenses.append({"position": position, "amount": expe})

func addPositionRevenue(position, amount):
	var expe = int(amount)
	revenues.append({"position": position, "amount": expe})


func newWeek():
	var sumRev = 0
	var sumExp = 0
	var text = ""
	
	addPositionExpenses("Rent", 300)

	var repay = 0
	for credit in credits:
		var total = float(credit.amount * (1 + float(credit.rate) / 100))
		var payRate = total / 24
		var remaining = max(0, total - (Global.GI.Week.week - credit.week) * payRate )
		if remaining > 0:
			repay += payRate
	addPositionExpenses("Loan repay", repay)
	
	text += "Balance Sheet\n\n"
	text += "Revenue\n------------------------------------------\n"
	for i in range(revenues.size()):
		text += revenues[i].position + " $" + str(revenues[i].amount) + "\n"
		sumRev += revenues[i].amount
	text += "\nSum: $" + str(sumRev) + "\n\n"

	text += "Expenses\n------------------------------------------\n"
	for i in range(expenses.size()):
		text += expenses[i].position + " $" + str(expenses[i].amount) + "\n"
		sumExp += expenses[i].amount
	text += "\nSum: $" + str(sumExp) + "\n\n"

	text += "------------------------------------------\n"
	if (sumRev - sumExp) < 0:
		text += "Total: [color=#e83b3b]$" + str(sumRev - sumExp) + "[/color]\n"
	else:
		text += "Total: $" + str(sumRev - sumExp) + "\n"
	cash = cash + sumRev - sumExp
	
	if (cash) < 0:
		text += "\nCash: [color=#e83b3b]$" + str(cash) + "[/color]\n"
	else:
		text += "\nCash: $" + str(cash) + "\n"
	$Text.bbcode_text = text
	
	revenues.clear()
	expenses.clear()

func _on_BtnClose_button_up():
	get_parent().closeActive()
