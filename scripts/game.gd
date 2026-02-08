extends Node2D

var score: int = 0;
var speed: float = 195.0;

var speed_threshold: int = 10;

func _ready() -> void:
	$Timer.start();

func _on_timer_timeout() -> void:
	score += 1;
	
	# Update speed
	if (score % 10 == 0):
		speed = minf(800.0, speed + 5.0);
		#print("New speed %d" % speed);
	
	$Label.text = "Score: %d" % score;
	$Timer.start();


func _on_rex_game_over() -> void:
	$Timer.stop();
