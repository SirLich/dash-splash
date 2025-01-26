extends CanvasLayer

func _ready():
	Bus.on_player_fell.connect(on_player_fell)
	Bus.on_game_started.connect(on_game_started)
	Bus.on_star_collected.connect(on_star_collected)
	Bus.on_spike_collected.connect(on_spike_collected)
	Bus.on_flutter_collected.connect(on_flutter_collected)
	Bus.on_micro_collected.connect(on_micro_collected)

	
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
	
func on_spike_collected(star):
	spikes += 1
	spike_count.text = str(spikes)
	
func on_flutter_collected(star):
	flutters += 1
	flutter_count.text = str(flutters)
	
func on_micro_collected(star):
	micros += 1
	micro_count.text = str(micros)
	
var stars = 0
var deaths = 0
var spikes = 0
var flutters = 0
var micros = 0

@export var star_count : Label
@export var death_count : Label
@export var spike_count : Label
@export var flutter_count : Label
@export var micro_count : Label
