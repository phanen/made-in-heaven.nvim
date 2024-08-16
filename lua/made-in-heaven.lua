-- TODO: vim.on_key

local _, fn, uv = vim.api, vim.fn, vim.uv or vim.loop

local timeout = ...
local _step = (function()
  local prev_key, prev_time, moved = nil, 0, 0
  local step_from_count = function(count, spec)
    for i, upper in ipairs(spec) do
      if count < upper then return i end
    end
    return #spec -- + (moved - spec[#spec])
  end

  return function(key, spec)
    if key ~= prev_key then
      prev_key, prev_time, moved = key, 0, 0
    else
      local time = uv.hrtime()
      local elapsed = time - prev_time
      prev_time = time
      moved = elapsed > timeout and 0 or moved + 1
    end
    return step_from_count(moved, spec)
  end
end)()

local _key = function(key, spec)
  return function()
    if vim.v.count > 0 or fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then return key end
    return _step(key, spec) .. key
  end
end

local _key_jk = function(key, spec)
  -- always use gj/gk (to use j/k: `:norm! j`)
  return function()
    if vim.v.count > 0 then return 'g' .. key end
    if fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then return 'g' .. key end
    return _step(key, spec) .. 'g' .. key
  end
end

-- special case
local _key_ctrl_d = function(key, spec)
  return function()
    if vim.v.count > 0 or fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then return key end
    local step = _step(key, spec)
    return math.floor(step * vim.o.lines) .. key
  end
end

local _cmd = function(cmd, spec)
  return function()
    if vim.v.count > 0 or fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then return cmd end
    return '<cmd>' .. _step(cmd, spec) .. cmd .. '<cr>'
  end
end

local placeholder = '󱗃'
local _any = function(any, spec)
  return function() return (any:gsub(placeholder, _step(any, spec))) end
end

-- configs
local h_spec = { 7, 14, 20, 26, 31, 36, 40, 45, 49, 52, 51 }
local v_spec = { 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60 }
timeout = 150 * 1e6 -- nanosecond
return setmetatable({
  h = _key('h', h_spec),
  l = _key('l', h_spec),
  j = _key_jk('j', v_spec),
  k = _key_jk('k', v_spec),
  ['<c-d>'] = _key_ctrl_d('<c-d>', v_spec),
  ['<c-u>'] = _key_ctrl_d('<c-u>', v_spec),
}, {
  __index = function(_, key)
    if key:match('^[wbeWBEnN]$') then return _key(key, h_spec) end
    if key:match(placeholder) then return _any(key, h_spec) end
    local cmd = key:match('^<[cC]md>(.+)<[cC]r>$')
    if cmd then return _cmd(cmd, h_spec) end
    error('[made-in-heaven] unsupported: ' .. key)
    return _key(key, h_spec)
  end,
})
