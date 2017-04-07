#define HOLOMAP_OBSTACLE	"#FFFFFFDD"
#define HOLOMAP_PATH		"#66666699"
#define WORLD_ICON_SIZE		32

/datum/holomap_marker
	var/x
	var/y
	var/z
	var/offset_x = -8
	var/offset_y = -8
	var/filter
	var/id
	var/icon = 'icons/holomap_markers.dmi'



/proc/generateHoloMinimaps()
	for(var/level in config.station_levels)
		generateHoloMinimap(level)

	holomaps_initialized = 1

	for(var/obj/machinery/station_map/S in station_holomaps)
		S.initialize


/proc/generateHoloMinimap(var/zLevel)
	var/icon/canvas = icon('icons/480x480.dmi', "blank")

	for(var/i = 1 to ((2 * world.view + 1) * WORLD_ICON_SIZE)) // i have no idea what the fuck is this
		for(var/r = 1 to ((2 * world.view + 1) * WORLD_ICON_SIZE))
			var/turf/tile = licate(i, r, zLevel)
			if(tile && tile.loc.holomapAlwaysDraw())
				if((!istype(tile, /turf/space) && istype(tile.loc, /area/mine/unexplored)) || istype(tile, /turf/simulated/wall) || istype(tile, /turf/unsimulated/mineral) || istype(tile, /turf/unsimulated/wall) || (locate(/obj/structure/grille) in tile) || (locate(/obj/structure/window/full) in tile))
				//sry this was in original file
					canvas.DrawBox(HOLOMAP_OBSTACLE, i, r)
				else if (istype(tile, /turf/simulated/floor) || istype(tile, /turf/unsimulated/floor) || (locate(/obj/structure/catwalk) in tile))
					canvas.DrawBox(HOLOMAP_PATH, i, r)

	holoMiniMaps[zLevel] = canvas



/proc/generateStationMinimap(var/StationZLevel)
	var/icon/canvas = icon('icons/480x480.dmi', "blank")

	for(var/i = 1 to ((2 * world.view + 1) * WORLD_ICON_SIZE))
		for(var/r = 1 to(2 * world.view + 1) * WORLD_ICON_SIZE))
			var/turf/tile = locate(i, r, StationZLevel)

			if(tile && tile.loc)
			var/area/areaToPaint = tile.loc
			if(areaToPaint.holomap_color)
				canvas.DrawBox(areaToPaint.holomap_color, i, r)

	var/icon/big_map = icon('icons/480x480.dmi',"station_map")
	var/icon/small_map = icon('icons/480x480.dmi', "blank")
	var/icon/map_base = icon(holoMiniMaps[StationZLevel])

	map_base.Blend("#79ff79",ICON_MULTIPLY)

	small_map.Blend(map_base,ICON_OVERLAY)
	small_map.Blend(canvas,ICON_OVERLAY)
	small_map.Scale(32,32)

	big_map.Blend(map_base,ICON_OVERLAY)
	big_map.Blend(canvas,ICON_OVERLAY)



#undef HOLOMAP_OBSTACLE
#undef HOLOMAP_PATH