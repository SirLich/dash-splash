extends CanvasLayer

func _ready():
	Bus.on_player_fell.connect(on_player_fell)
	Bus.on_game_started.connect(on_game_started)
	Bus.on_star_collected.connect(on_star_collected)
	
func on_game_started():
	stars = 0
	deaths = 0
	spikes = 0
	
func on_player_fell(player):
	deaths += 1
	death_count.text = str(deaths)

func on_star_collected(star):
	stars += 1
	star_count.text = str(stars)
	
var stars = 0
var deaths = 0
var spikes = 0

@export var star_count : Label
@export var death_count : Label
@export var spike_count : Label
