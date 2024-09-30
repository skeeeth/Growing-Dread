extends Node

signal day_progressed
var day:int = 0
enum interactions{Till,Plant,Water,Harvest,}
enum states{Untilled,Tilled,Growing,Ripe,Dead}

func next_day():
	day += 1;
	day_progressed.emit()

func _input(event):
	if event.is_action_pressed("0"):
		next_day()
