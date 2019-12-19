extends Node

var cash = 5000

var Club = null

func _ready():
	pass 

func connectClub(node):
	Club = node

func newWeek():
	pass

func hireNewArtist(id):
	var talent = Club.get_child(id)
	
	if Data.calculateSalary(talent) <= cash:
		Club.remove_child(talent)
		self.add_child(talent)
		talent.signed = true
		talent.duration = 2
		talent.relationship = min(10, talent.relationship + 5)
	else:
		print("Not enough money")
	


