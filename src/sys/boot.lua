-- /sys/boot.lua
-- Initializes the system

local function log(fmt, ...)
	print(("[%f] " .. fmt):format(os.clock(), ...))
end

local function contains(tbl, val)
	for k, v in pairs(tbl) do
		if v == val then
			return true
		end
	end

	return false
end

local function init(args)
	local quiet = contains(args, "quiet")

	local function l(...)
		if not quiet then return log(...) end
	end

	term.redirect(term.native())
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.setCursorBlink(true)
	term.clear()
	term.setCursorPos(1,1)

	l "Booting Radium"
end

local bootArgs = {}
if fs.exists(sysPath("cmdline.txt")) then
	local f = fs.open(sysPath("cmdline.txt"), "r")
	local d = f.readAll()
	f.close()

	for arg in d:gmatch("%S+") do
		table.insert(bootArgs, arg)
	end
end

init(bootArgs)

sleep(5)