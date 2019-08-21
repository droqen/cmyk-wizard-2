extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = File.new()
	f.open("res://red_devil_test/0_0.json", File.READ)
	var json_str = f.get_as_text()
	var game_data = parse_json(json_str)
	var tile_data = game_data.layers[0].data
	var map_w = game_data.layers[0].width
	var map_h = game_data.layers[0].height
	var x = 0
	var y = 0
	var solid_tiles = [11]
	var spawn_tiles = {2:load("res://red_devil_test/red_devil_player.tscn")}
	
	$vis_tilemap.clear()
	$collisions_tilemap.clear()
	
	for tile in tile_data:
		tile = int(tile)
		if spawn_tiles.has(tile):
			print('spawn ',tile)
			# no tilemap. only spawn.
			var spawn = spawn_tiles[tile].instance()
			get_tree().get_root().call_deferred("add_child",spawn)
			spawn.position = (  $vis_tilemap.map_to_world(Vector2(x,y)) + $vis_tilemap.map_to_world(Vector2(x+1,y+1))  ) / 2
			tile = 1 # blank black tile.
		
		
		$vis_tilemap.set_cell(x,y,0,false,false,false,Vector2(int(tile-1)%10,int(tile-1)/10))
		if tile in solid_tiles:
			$collisions_tilemap.set_cell(x,y,0)
		
		x+=1
		if x >= map_w:
			x=0
			y+=1
	
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
