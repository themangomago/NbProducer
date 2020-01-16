extends Sprite


func setStars(val):
	if val == 0:
		self.frame = 10
	else:
		self.frame = val - 1
