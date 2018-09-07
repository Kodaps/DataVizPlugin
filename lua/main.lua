-- 
-- Abstract: shapes Library Plugin Test Project
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
--
------------------------------------------------------------

-- Load plugin library
local shapes = require "plugin.shapes"

-------------------------------------------------------------------------------
-- BEGIN (Insert your sample test starting here)
-------------------------------------------------------------------------------
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = display.contentCenterX, display.contentCenterY


local w, h = 50, 50
local x, y = display.contentCenterX, display.contentCenterY
local radius = screenH*.1

local arc = shapes.newArc({
	start_angle = 20,
	end_angle = 90,
	radius = radius,
	stroke = 5,
})

arc.x, arc.y = halfW, screenH*.15

local hexagon = shapes.newRegularPolygon({
	nb = 6,
	radius = radius
})

hexagon.x, hexagon.y = halfW, screenH*.4


local pie = shapes.newPie({
	start_angle = 20,
	end_angle = 90,
	radius = radius,
	stroke = 5,
})

pie.x, pie.y = halfW, screenH*.7


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------