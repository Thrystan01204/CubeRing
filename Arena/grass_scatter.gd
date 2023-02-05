@tool
extends Node3D


@export var generate : bool = false :  set = place_grass
@export var count = 100 : set = place_grass
@export var rect : Vector2 : set = place_grass


func place_grass(val):
	generate = false
	$MultiMeshInstance3D.



