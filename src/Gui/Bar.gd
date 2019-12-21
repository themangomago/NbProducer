extends Control

func setValue(val):
	$ProgressBar.value = val
	
func setup(dname, startVal):
	$ProgressBar.value = startVal
	$Label.set_text(dname)
