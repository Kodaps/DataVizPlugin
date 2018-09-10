local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name='plugin.shapes', publisherId='com.kodaps' }

display.setDefault( "isAnchorClamped", false )

-------------------------------------------------------------------------------
-- BEGIN (Insert your implementation starting here)
-------------------------------------------------------------------------------

local function deg2rad(angle)
	angle = angle or 0
    return math.pi * (angle/180 - .5)
end

local cos = math.cos
local sin = math.sin

local function dcos(dangle)
    return cos(deg2rad(dangle))
end

local function dsin(dangle)
    return sin(deg2rad(dangle))
end


local function arc(start_angle, end_angle, radius, step)


    if start_angle > end_angle then 
        local _ = end_angle
        end_angle = start_angle
        start_angle = _
    end

    step = step or 5

    --local _start = deg2rad(start_angle)
    --local _end = deg2rad(end_angle)

    --local bit = deg2rad(step or 5)

    --if _start > _end then
    --   local _ = _end
    --    _end = _start
    --    _start = _
    --end
    local points = {}

    local _count = 1

    for deg = start_angle, end_angle, step do
        points[_count] = radius*dcos(deg)
        points[_count+1] = radius*dsin(deg)
        _count = _count + 2
    end

    return points


end


function lib.newDot(data)

	data = data or {}

    local mat = display.newCircle(data.x or 0, data.y or 0, 3)
    mat:setFillColor(1,0,0)

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

    print("arc anchors", mat.anchorX, mat.anchorY)

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end

function lib.newPie (data)

	data = data or {}

	local ret = arc(data.start_angle, data.end_angle, data.radius)

    local angle = math.abs(data.end_angle - data.start_angle)

    -- if the angle acute, etc. ?
    -- and which quadran is the angle in ?

    -- if angle = 180 then it is in the center 

    -- 

    local x_start = dcos(data.start_angle)
    local x_end = dcos(data.end_angle)

    local y_start = dsin(data.start_angle)
    local y_end = dsin(data.end_angle)

    local x = x_start - x_end
    -- local xmid = 


    local x_length = x_start - x_end

    local anchorX, anchorY = 0.5,0.5


    if angle < 180 then


        anchorY = 0

        if angle < 90 then
            anchorX = 0
        end
    end


	table.insert(ret, 1, 0)
    table.insert(ret, 1, 0)


    local mat = display.newPolygon(0,0, ret)
    mat.strokeWidth = data.stroke or 1
    mat.anchorX, mat.anchorY = anchorX, anchorY

    _x, _y = mat:contentToLocal(0, 0)
    print(_x, _y)


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
