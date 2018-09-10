local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name='plugin.shapes', publisherId='com.kodaps' }

-------------------------------------------------------------------------------
-- BEGIN (Insert your implementation starting here)
-------------------------------------------------------------------------------

local function deg2rad(angle)
	angle = angle or 0
    return math.pi * angle/180
end

local cos = math.cos
local sin = math.sin

local function arc(start_angle, end_angle, radius, step)

    local _start = deg2rad(start_angle)
    local _end = deg2rad(end_angle)

	local bit = deg2rad(step or 5)
	
	

    if _start > _end then
        local _ = _end
        _end = _start
        _start = _
    end

    local points = {}
    local _count = 1
    local _curr = _start

    while (_curr <= _end) do
        points[_count] = radius*cos(_curr)
        points[_count+1] = radius*sin(_curr)
        _count = _count +2
        _curr = _curr + bit
    end

    return points

end


local function reverse_arc(start_angle, end_angle, radius, step)

    local _start = deg2rad(start_angle)
    local _end = deg2rad(end_angle)

    local bit = deg2rad(step or 5)

    if _start > _end then
        local _ = _end
        _end = _start
        _start = _
    end

    local points = {}
    local _count = 1
    local _curr = _start

    while (_curr <= _end) do
        points[_count] = radius*cos(_curr)
        points[_count+1] = radius*sin(_curr)
        _count = _count +2
        _curr = _curr + bit
    end

    return points

end



function lib.newCircleSegment(data)

	data = data or {}

	local ret = arc(data.start_angle, data.end_angle, data.radius)

	local bit2 = deg2rad(-5)

	local ret2 = arc(data.end_angle, data.start_angle, data.radius, bit2)


    local mat = display.newLine(unpack(ret))
    mat.strokeWidth = data.stroke or 1

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end



function lib.newArc (data)

	data = data or {}

	local ret = arc(data.start_angle, data.end_angle, data.radius)

    local mat = display.newLine(unpack(ret))
    mat.strokeWidth = data.stroke or 1

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end

function lib.newPie (data)

	data = data or {}

	local ret = arc(data.start_angle, data.end_angle, data.radius)

	table.insert(ret, 1, 0)
	table.insert(ret, 1, 0)

    local mat = display.newPolygon(0,0, ret)
    mat.strokeWidth = data.stroke or 1

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end



function lib.newRegularPolygon(data)

	data = data or {}

	local nb = (data.nb or 3)

	-- if nb < 3 then not a polygon

	local step = 360/nb

	local ret = arc(0, 359, data.radius, step)

    local mat = display.newPolygon(0,0, ret)
    mat.x = data.x or 0
    mat.y = data.y or 0

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------

-- Return library instance
return lib
