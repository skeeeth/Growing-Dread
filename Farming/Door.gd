extends StaticBody2D
class_name Door

func interact(player):
	$"../..".interact(player) #Bad practice, but it'll do for now
							  #We should eventually make the interaction system more generalized + robust
