extends Control

@export var bubble_container : Node2D
@export var respawn_container : Node2D
@export var respawn_texture : Texture

@export var interesting_color : Color
@export var player_color : Color
@export var player : Node2D

@export var star_texture : Texture
@export var star_color : Color

func _process(delta):
	queue_redraw()
	
func _draw():
	var pos_scale = Vector2(0.02, 0.02)
	
	for child in bubble_container.get_children():
		if not child:
			continue
			
		if not child is Bubble:
			continue
			
		var size = child.get_size_display() * 2
		var pos = child.global_position * pos_scale
		
		if child.get_child_count() > 200:			
			draw_circle(pos, size, interesting_color)
			draw_arc(pos, size, 0, 360, 16, Color.BLACK, 3)
		else:
			draw_circle(pos, size, Color.BLACK)
			
		draw_circle(player.global_position * pos_scale, 5, player_color)
	
	for star in get_tree().get_nodes_in_group("star"):
		var star_pos = (star.global_position  * pos_scale) + Vector2(-12, -12)
		draw_texture(star_texture, star_pos, star_color)

	var c = Color("#ef9389")
	c.a = 0.75
	var active_child = respawn_container.get_active_anchor()
	var cpos = (active_child.global_position  * pos_scale) + Vector2(-14, -14)
	draw_texture(respawn_texture, cpos, c)
