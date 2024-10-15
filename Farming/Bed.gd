extends StaticBody2D
class_name Bed

@export var sleep_fade_duration:float
@export var sleep_duration:float

func interact(player):
	#Farming.next_day()
	
	player.is_sleeping = true
	
	get_tree().create_tween().tween_property($SleepingScreenCover, "modulate", Color.BLACK, sleep_fade_duration)
	$SleepTimer.start(sleep_fade_duration)
	await $SleepTimer.timeout
	Farming.go_to_sleep()
	
	$SleepTimer.start(sleep_duration)
	await $SleepTimer.timeout

	get_tree().create_tween().tween_property($SleepingScreenCover, "modulate", Color.TRANSPARENT, sleep_fade_duration)
	$SleepTimer.start(sleep_fade_duration)
	await $SleepTimer.timeout
	Farming.wake_up()
