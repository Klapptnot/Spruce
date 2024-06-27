-- Not used more than a couple of times power functions

local spruce = require("src.warm.spruce")
local str = require("src.warm.str")
local main = {}

---Sleep simple, allowing to sleep n seconds
--
---To sleep n milliseconds, use fractions of seconds (0.5, 0.225)
---@param n number
function main.sleep(n)
  local t0 = os.clock()
  while os.clock() - t0 <= n do
  end
end

---Get the bit lenght of a integer (Bits used to store it)
---@param i integer
---@return integer
function main.bit_length(i)
  local len = 0
  if i > 255 then
    len = 8
    i = math.floor(i / 255)
  end
  while i > 0 do
    i = math.floor(i / 2)
    len = len + 1
  end
  return len
end

---Simple expect() + opr() functions to test return values
---@param this any
---@param msg? string
---@param verbose? boolean
function main.expect(this, msg, verbose)
  if msg == nil then msg = "... unnammed" end
  if verbose == nil then verbose = false end
  assert(type(verbose) == "boolean", "argument #3 to 'expect' must be a boolean")
  local function print_error(a, b)
    print("\x1b[38;5;9m[FAILED]\x1b[0m: " .. msg)
    print("\x1b[38;5;5mExpected\x1b[0m: " .. tostring(b))
    print("\x1b[38;5;5mGot\x1b[0m     : " .. tostring(a))
  end
  if verbose == true then msg = msg .. " is " .. tostring(this) end
  local function proc(bad, val)
    if bad then
      print_error(this, val)
      return
    end
    print("\x1b[38;5;10m[PASSED]\x1b[0m: " .. msg)
  end
  local oprs = {}
  ---`this` must be equal to `b`
  function oprs.eq(b) return proc(this ~= b, b) end

  ---`this` must not be equal to `b`
  function oprs.ne(b) return proc(this == b, b) end

  ---`this` must be less than `b`
  function oprs.lt(b) return proc(not (this < b), b) end

  ---`this` must be less or equal to `b`
  function oprs.le(b) return proc(not (this <= b), b) end

  ---`this` must be greater to `b`
  function oprs.gt(b) return proc(not (this > b), b) end

  ---`this` must be greater or equal to `b`
  function oprs.ge(b) return proc(not (this >= b), b) end

  -- Type and value checks
  oprs.is = {}
  ---`this` must be of type `b`
  ---@param b type
  function oprs.is.it(b)
    this = type(this)
    local r = this ~= b
    return proc(r, b)
  end

  ---`this` must not be of type `b`
  ---@param b type
  function oprs.is.no(b)
    this = type(this)
    local r = this == b
    return proc(r, b)
  end

  ---`this` must be ***nil***
  function oprs.is.Nil() return proc(this ~= nil, nil) end

  ---`this` must be ***true***
  function oprs.is.True() return proc(this ~= true, nil) end

  ---`this` must be ***false***
  function oprs.is.False() return proc(this ~= false, nil) end

  return oprs
end

function main.fix_utf()
  --- ΓÇª  …
  local patt = "[%z\0-\x7F\xC2-\xFD][\x80-\xBF]*"
end

-- Number to hex notation
---@param i integer
---@return string
function main.hex(i) return string.format("0x%x", tostring(i)) end

function main.execute(prog, strip)
  local exeo = io.popen(prog, "r")
  if exeo == nil then return end
  local out = exeo:read("a")
  exeo:close()
  if strip then out = out:gsub("^[\n|%s]*(.-)[\n|%s]*$", "%1") end
  return out
end

---Return if system is Unix or Windows (Unknown if not found)
---@param num? boolean Return number instead of name
---@return "Unix"|1|"Windows"|2|"Unknown"|0
function main.systype(num)
  if num == nil then num = false end
  assert(type(num) == "boolean", "argument #1 to 'systype' must be a boolean")
  local ps = package.config:sub(1, 1)
  return spruce.match(ps)({
    ["/"] = num and 1 or "Unix",
    ["\\"] = num and 2 or "Windows",
    _def = num and 0 or "Unknown",
  })
end

---Run a single command and get stdout, stderr and exit code
--
---NOTE: On Windows without powershell, exit code will always be 0
---@param cmd string
---@return {out:string, err:string, exi:integer?}
function main.nrun(cmd)
  local fifo = os.tmpname() -- Create a temporary FIFO file
  ---@cast cmd string
  cmd = spruce.match(main.systype())({
    Windows = function()
      -- Exit code does not work (for me)? I saw that it should work, but it doesn't
      local fst =
        [[{1} 2>>{2} & ( echo //--//--//^<%ERRORLEVEL%^>//--//--// ) & ( type {2} ) & ( del {2} )]]
      local f, s = io.popen("powershell -Version 2>&1")
      ---@cast f file*
      if s == nil then
        -- If not error message with ...
        if f:read("a"):match("'powershell'") == nil then
          fst =
            [[powershell -Command "{1} 2>{2}; Write-Host //--//--//<${LASTEXITCODE}>//--//--// -NoNewLine; Get-Content '{2}'; $null = Remove-Item '{2}'"]]
        end
        f:close()
      end
      return str.format(fst, cmd, fifo)
    end,
    Unix = function()
      return str.format(
        [[{1} 2>>{2};echo -n "//--//--//<${?}>//--//--//";cat {2};rm {2}]],
        cmd,
        fifo
      )
    end,
  })

  local handle = io.popen(cmd, "r")
  ---@cast handle file*
  local output = handle:read("a")
  handle:close()

  local stdout, exit, stderr =
    string.match(output, "(.-)//%-%-//%-%-//<(%d+)>//%-%-//%-%-//(.*)")
  return {
    out = stdout or "",
    err = stderr or "",
    exi = tonumber(exit),
  }
end

---Get the path to caller function's file parent folder or path to file
---@param full? boolean
---@param lvl? integer
---@return string
function main.fwd(full, lvl)
  if full == nil then full = false end
  assert(type(full) == "boolean", "argument #1 to 'fwd' must be a boolean")
  if lvl == nil then lvl = 1 end
  assert(type(lvl) == "number", "argument #2 to 'fwd' must be a integer")

  local ps = package.config:sub(1, 1)
  local command = spruce.match(main.systype(true))({
    "pwd",
    "CHDIR",
    _def = function() error("could not get system type") end,
  })

  local pcwd = main.execute(command, true)
  if pcwd == nil then return "./" end
  local csrc = debug.getinfo(lvl + 1).source
  if not str.starts_with(csrc, "@" .. pcwd) and str.starts_with(csrc, "@%.") then
    csrc = csrc:gsub("^@", pcwd .. ps)
  else
    csrc = csrc:sub(2)
  end
  -- Replacing '/./' -> '/' or '\.\' -> '\' Not needed in a embedded Lua
  csrc = csrc:gsub(ps .. "%." .. ps, ps)
  if full then return csrc end
  local cpm = csrc:match("^(.*)" .. ps)
  return cpm
end

---Return the content of a file as a string. nil on error
---@param filepath string
---@return string?
function main.file_as_str(filepath)
  local file = io.open(filepath, "r")
  if not file then return end
  local content = file:read("a")
  file:close()
  return content
end

---Create a file with s as its content
---@param s string
---@param filepath string
function main.str_to_file(s, filepath)
  local file = io.open(filepath, "w")
  if not file then error(string.format("Error opening file: %s", filepath)) end

  file:write(s)
  file:close()
end

---Get some of the content of a file; from line {inp} to {enp} line
---@param filepath string
---@param inp? integer
---@param enp? integer
---@return string?, table?
function main.get_file_range(filepath, inp, enp)
  local file = io.open(filepath, "r")
  if not file then return end
  file:close()

  local lines = {}
  local linestr = ""
  local cl = 1

  for ln in io.lines(filepath) do
    if cl >= inp and cl <= enp then
      lines[#lines + 1] = {
        n = cl,
        c = ln,
      }
      linestr = linestr .. "\n" .. ln
    end
    cl = cl + 1
  end

  return linestr, lines
end

---Function to get the current time (default) or time in `epoch` number
---@param epoch? integer
---@return table
function main.timenow(epoch)
  if epoch == nil then epoch = os.time() end
  assert(type(epoch) == "number", "argument #1 to 'timenow' must be an integer|number")
  local seconds = math.floor(epoch)
  local hours, remaining_seconds = math.floor(seconds / 3600), seconds % 3600
  local minutes, seconds = math.floor(remaining_seconds / 60), remaining_seconds % 60

  -- Return time as a table
  return {
    ds = math.floor(hours / 24),
    hs = hours % 24,
    mn = minutes,
    ss = seconds,
    rw = epoch,
  }
end

-- Function to add two time tables
function main.timeadd(add, now)
  --
end

-- Function to subtract two time tables
function main.timesub(now, past)
  if past.rw > now.rw then
    now, past = past, now
  end
  return main.timenow(now.rw - past.rw)
end

---Return the time a function took to return
---@generic R
---@param fun? fun(any):R
---@param ... any
---@return table -Time data
---@return R? Function return value
function main.timeit(fun, ...)
  local it = os.clock()
  assert(fun ~= nil, "No valid fun")
  local rt = fun(...)
  local st = os.clock()

  -- Elapsed time
  local tt = st - it
  local et = {}
  et.hs = math.floor(tt / 3600)
  et.mn = math.floor(tt % 3600 / 60)
  et.ss = math.floor(tt % 3600 % 60)
  et.ms = math.floor(((tt % 3600 % 60) - et.ss) * 1000)
  et.us = math.floor(((((tt % 3600 % 60) - et.ss) * 1000) - et.ms) * 1000)

  -- Return elapsed time components and the return of the function
  return et, rt
end

return main
