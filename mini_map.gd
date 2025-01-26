extends Control

@export var bubble_container : Node2D
@export var respawn_container : Node2D
@export var respawn_texture : Texture

@export var interesting_color : Color
@export var player_color : Color
@export var player : Node2D

func _process(delta):
	queue_redraw()
	
func _draw():
	var pos_scale = Vector2(0.02, 0.02)
	
	for child in bubble_container.get_children():
		var size = child.initial_size * 2
		var pos = child.global_position * pos_scale
		
		if child.get_child_count() > 200:			
			draw_circle(pos, size, interesting_color)
			draw_arc(pos, size, 0, 360, 16, Color.BLACK, 3)
		else:
			draw_circle(pos, size, Color.BLACK)
			
		draw_circle(player.global_position * pos_scale, 5, player_color)


	var cpos = respawn_container.get_active_anchor().global_position * pos_scale
	draw_texture(respawn_texture, cpos, Color.HOT_PINK)
