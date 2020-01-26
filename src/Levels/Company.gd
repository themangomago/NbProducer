extends Node

var Club = null

var salesWeeks = [0.4, 0.6, 0.8, 1.0, 0.9, 0.9, 0.8, 0.7, 0.5, 0.3, 0.2, 0.1]

func _ready():
	pass 

func connectClub(node):
	Club = node

func newWeek():
	var expanses = 0
	for artist in self.get_children():
		expanses += artist.contract.salary

	Global.GI.Balance.addPositionExpenses("Contracts", expanses)
	handleSales()


func handleSales():
	var curWeek = Global.GI.Week.week
	Global.GI.Newspaper.clearCharts()
	for album in Global.GI.Albums.get_children():
		if album.data.released == true and album.data.sales == true:
			var weeksOnMarket = curWeek - album.data.releaseWeek
			
			if weeksOnMarket >= salesWeeks.size():
				album.data.sales = false
				Global.GI.Notification.notify(album.data.title + " was taken off market.", "Label")
				return
			else:
				var weekMod = salesWeeks[weeksOnMarket]
				var albumQ = album.data.quality
				# 3: 9  * 1000  = 9k
				# 5: 25 * 1000  = 25k
				# 10: 100 * 1000 = 100k
				var sales = (int(album.data.quality)*int(album.data.quality)) * 1000 * weekMod
				
				Global.GI.Balance.addPositionRevenue("Rev. " + album.data.title, int((sales*album.contract.percentage)/100))
				Global.GI.Newspaper.addToChart(album, sales)
				
	Global.GI.Newspaper.updateCharts()


func hireNewArtist(id):
	print("hireNewArtist")
	pass
#	var talent = Club.get_child(id)
#
#	if Data.calculateSalary(talent) <= cash:
#		Club.remove_child(talent)
#		self.add_child(talent)
#		talent.signed = true
#		talent.duration = 2
#		talent.relationship = min(10, talent.relationship + 5)
#	else:
#		print("Not enough money")
#


