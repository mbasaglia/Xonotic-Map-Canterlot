textures/canterlot/window_nm
{
	qer_editorimage textures/canterlot/window_nm.png
	q3map_surfacelight 900
	
	surfaceparm nolightmap
	cull none
	
	{
		map textures/canterlot/window_nm.png
	}
}
textures/canterlot/window_castle
{
	qer_editorimage textures/canterlot/window_castle.png
	q3map_surfacelight 900
	
	surfaceparm nolightmap
	cull none
	
	{
		map textures/canterlot/window_castle.png
	}
}
textures/canterlot/window_fancy
{
	qer_editorimage textures/canterlot/window_fancy.png
	q3map_surfacelight 900
	
	surfaceparm nolightmap
	cull none
	
	{
		map textures/canterlot/window_fancy.png
	}
}

/*textures/canterlot/marble
{
	qer_editorimage textures/canterlot/marble.jpg
	q3map_lightmapBrightness 0.1
	
	{
		map $lightmap
		rgbGen const ( 0.5 0.5 0.5 )
		alphaGen const 0.5
	}
	{
		map textures/canterlot/marble.jpg
		//rgbGen identity
	}
}*/


textures/canterlot/railing1
{
	qer_editorimage textures/canterlot/railing1.png
	cull none
	surfaceparm trans
	{
		map textures/canterlot/railing1.png
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
	}
}

textures/canterlot/roof_golden_top
{
	qer_editorimage textures/canterlot/roof_golden_top.jpg
	
	{
		map textures/canterlot/roof_golden.jpg
	}
}


textures/canterlot/window_light
{
	map textures/canterlot/window_light.png
	surfaceparm trans	
	surfaceparm nomarks	
	surfaceparm nonsolid
	surfaceparm nolightmap
	
	{
		map textures/canterlot/window_light.png
		blendFunc add
	}
}

textures/canterlot/grate
{
	qer_editorimage textures/canterlot/grate.png
	cull none
	surfaceparm trans
	{
		map textures/canterlot/grate.png
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
	}
}


textures/canterlot/water
{
	qer_editorimage textures/liquids_water/water0.tga
	qer_trans 20
	surfaceparm nomarks
	surfaceparm trans
	surfaceparm water
	surfaceparm nolightmap
	cull none
	q3map_globaltexture
	{
		map textures/liquids_water/water0.tga
		tcmod scale 1.2 0.7
		tcMod scroll 0.084 0.049
		blendfunc blend
	}
}

textures/canterlot/crystal
{
	q3map_surfacelight 10
	{
		map textures/canterlot/crystal.jpg
		tcgen environment
		rgbgen wave sin .12 .2 0 0
	}
}
