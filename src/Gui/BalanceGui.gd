extends Control


var cash = 10000

var expenses = []
var revenues = []

var sheet = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addPositionExpenses(position, expanses):
	expenses.append({"position": position, "amount": expanses})


func addPositionRevenue(position, expanses):
	revenues.append({"position": position, "amount": expanses})



func newWeek():
	var label = ""
	var sumRev = 0
	var sumExp = 0

	for i in range(expenses.size()):
		label += expenses[i].position + " " + str(expenses[i].amount) + "\n"
		sumExp += expenses[i].amount
	$ExpLabel.set_text(label)
	$SumExp.set_text(str(sumExp))
	
	label = ""
	for i in range(revenues.size()):
		label += revenues[i].position + " " + str(revenues[i].amount) + "\n"
		sumRev += revenues[i].amount
	$ExpLabel.set_text(label)
	$SumRev.set_text(str(sumRev))
	$Cash.set_text(str(cash + sumRev - sumExp))

func _on_BtnClose_button_up():
	get_parent().closeActive()
