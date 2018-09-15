-- colors.lua
local colors ={}

local function hex2rgb(hex)

  if #hex == 4 or #hex==5 then
    local r = tonumber("0x"..hex:sub(2,2))/15
    local g = tonumber("0x"..hex:sub(3,3))/15
    local b = tonumber("0x"..hex:sub(4,4))/15
    local a
    if #hex == 5 then
      a = tonumber("0x"..hex:sub(5,5))/15
    end
    return {r,g,b,a}
  end

  if #hex == 7 or #hex==9 then 
    local r = tonumber("0x"..hex:sub(2,3))/255
    local g = tonumber("0x"..hex:sub(4,5))/255
    local b = tonumber("0x"..hex:sub(6,7))/255
    local a
    if #hex == 9 then
      a = tonumber("0x"..hex:sub(6,7))/255
    end
    return {r,g,b,a}
  end
end

-- temp fake

local _palette = {

    primary = {
        color = "blue", --     primary = "#0078c9"
        shade = "500"
    },
    accent = {
        color = "lightgreen",
        shade = "a400"
    }
}

local primary = nil
local accent = nil

local _cols = {}

-- http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c

--[[
 * Converts an RGB color value to HSL. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and l in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSL representation
]]
function rgbToHsl(r, g, b, a)
  --r, g, b = r / 255, g / 255, b / 255

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    local s
    if l > 0.5 then s = d / (2 - max - min) else s = d / (max + min) end
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l, a
end
--[[
 * Converts an HSL color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  l       The lightness
 * @return  Array           The RGB representation
]]
function hslToRgb(h, s, l, a)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r, g, b, a
end

--[[
 * Converts an RGB color value to HSV. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and v in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSV representation
]]
function rgbToHsv(r, g, b, a)

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end

--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  v       The value
 * @return  Array           The RGB representation
]]
function hsvToRgb(h, s, v, a)
  local r, g, b

  local i = Math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r , g, b, a
end



function colors:white()
  return unpack({1,1,1})
end


local _namedColors = {}
--[[
  topdarkblue = "#10456f",
  head_dark = "#151E23",
  head_bright = "#00DCFF",
  head_grey = "#A6A6A6"
}]]



function colors:black(alpha)
  alpha = alpha or 0.85
  return unpack({0,0,0, alpha})

end

function colors:primary()
    -- body
    if primary then
      return unpack(primary)
    end

    local col = _cols[_palette.primary.color][_palette.primary.shade]
    return unpack(col)

end


function colors:accent()
    -- body
    if accent then
      return unpack(accent)
    end

    local col = _cols[_palette.accent.color][_palette.accent.shade]
    return unpack(col)

end

function colors:white()
    -- body
    local col = {1,1,1}
    return unpack(col)

end

function colors:muted()
    -- body

    if (type(_palette.primary) == 'table') then
      local col = _cols[_palette.primary.color]["50"] or _cols[_palette.primary.color]["100"]
      return unpack(col)
    else
      return unpack(_cols["bluegrey"]["50"])

    end
end

local _palette

function colors:setPalette( _pal)
  _palette = _pal  
end 


function colors:get_color(_c)

  if type(_c) == 'table' then
    if _c.color and _c.shade then  
      return _cols[_c.color][_c.shade]
    else 
      return _c 
    end
  end


  if type(_c) == 'string' then

    if  (_namedColors[_c]) then
      return hex2rgb(_namedColors[_c])
    end

    if _cols[_palette or ""] and _cols[_palette or ""][_c or ""] then 
      return _cols[_palette or ""][_c or ""]
    end  


    return hex2rgb(_c)
  end

end

function colors:addNamedColors(_namedCols)
  for k,v in pairs(_namedColors or {}) do
    _namedColors[k] = v 
  end
end

function colors:getColor(key)
  local _col = self:get_color(key)
  return unpack(_col)
end



function colors:setup(colordata, _pal)

  _pal = _pal or _palette

  for col,palette in pairs(colordata) do
      _cols[col] = {}
      for key, hexcode in pairs(palette) do
          _cols[col][key] = hex2rgb(hexcode)
      end
  end

  if _pal then
    primary = self:get_color(_pal.primary)
    accent = self:get_color(_pal.accent)
    
    -- _namedColors = _pal

  end



end

setmetatable(colors, {
  __call = function (_, ...)
      return colors:getColor(...)
  end,
  __index = function (_, ...)
    return colors:get_color(...)
  end
})


return colors