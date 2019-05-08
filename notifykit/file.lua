local Notification, group
do
  local _obj_0 = require("notifykit")
  Notification, group = _obj_0.Notification, _obj_0.group
end
local split
split = function(sep, plain)
  if plain == nil then
    plain = false
  end
  return function(str, max)
    assert(sep ~= '')
    assert((max == nil) or (max >= 1))
    local res = { }
    if str:len() > 0 then
      max = max or -1
      local field, start = 1, 1
      local first, last = str:find(sep, start, plain)
      while first and max ~= 0 do
        res[field] = str:sub(start, first - 1)
        field = field + 1
        start = last + 1
        first, last = str:find(sep, start, plain)
        max = max - 1
      end
      res[field] = str:sub(start)
    end
    return res
  end
end
local splitSpaces = split(" +")
local lines
lines = function(text)
  if (text:sub(-1)) ~= "\n" then
    text = text .. "\n"
  end
  return text:gmatch("(.-)\n")
end
local parseNotification
parseNotification = function(text)
  local helper
  helper = function(line)
    local fields = splitSpaces(line)
    local toBody = table.concat((function()
      local _accum_0 = { }
      local _len_0 = 1
      for i, word in ipairs(fields) do
        if i > 6 then
          _accum_0[_len_0] = word
          _len_0 = _len_0 + 1
        end
      end
      return _accum_0
    end)(), " ")
    local urgency, timeout, category, icon, summary, body
    do
      local _obj_0 = splitSpaces(line)
      urgency, timeout, category, icon, summary, body = _obj_0[1], _obj_0[2], _obj_0[3], _obj_0[4], _obj_0[5], _obj_0[6]
    end
    body = body .. (" " .. toBody)
    local sl
    sl = function(x)
      return x == "/"
    end
    if sl(urgency) then
      urgency = "1"
    end
    if sl(timeout) then
      timeout = "-1"
    end
    if sl(category) then
      category = "notifykit"
    end
    if sl(icon) then
      icon = "dialog-information"
    end
    if sl(summary) then
      summary = "notifykit"
    end
    if sl(body) then
      body = ""
    end
    local _exp_0 = urgency
    if "low" == _exp_0 then
      urgency = "0"
    elseif "normal" == _exp_0 then
      urgency = "1"
    elseif "critical" == _exp_0 then
      urgency = "2"
    end
    local _exp_1 = timeout
    if "default" == _exp_1 then
      timeout = "-1"
    elseif "never" == _exp_1 then
      timeout = "0"
    end
    urgency = tonumber(urgency)
    timeout = tonumber(timeout)
    return {
      urgency = urgency,
      timeout = timeout,
      category = category,
      icon = icon,
      summary = summary,
      body = body
    }
  end
  local notifl
  do
    local _accum_0 = { }
    local _len_0 = 1
    for line in lines(text) do
      if not line:match("^;") then
        _accum_0[_len_0] = helper(line)
        _len_0 = _len_0 + 1
      end
    end
    notifl = _accum_0
  end
  if #notifl < 1 then
    error("Invalid file.")
  end
  return notifl
end
local compileNotification
compileNotification = function(notifl)
  do
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #notifl do
      local n = notifl[_index_0]
      _accum_0[_len_0] = Notification(n.summary, n.body, n.icon, n.timeout, n.urgency, n.category)
      _len_0 = _len_0 + 1
    end
    notifl = _accum_0
  end
  if #notifl == 1 then
    return notifl[1]
  else
    local unpack = unpack or table.unpack
    return group(unpack(notifl))
  end
end
return {
  parseNotification = parseNotification,
  compileNotification = compileNotification
}
