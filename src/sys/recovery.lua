-- /sys/recovery.lua
-- Handles boot-time errors

local err = ({...})[1]

local function wrapLines(text, w)
	local lines = {}
	local line

	for word in text:gmatch("%S+") do
		if line == nil then
			line = word
		elseif #(line .. word) + 2 >= w then
			table.insert(lines, line)
			line = word
		else
			line = line .. " " .. word
		end
	end

	if line ~= nil then
		table.insert(lines, line)
	end

	return lines
end

local function scrollLines(amt)
	local x, y = term.getCursorPos()
	term.setCursorPos(x, y + (amt or 1))
end

local function printCenterWrapped(text, w)
	local lines = wrapLines(text, w)

	local x, y = term.getCursorPos()
	for i, line in ipairs(lines) do
		term.setCursorPos(math.floor(w/2 - #line/2), y + i - 1)
		term.write(line)
	end

	scrollLines()
end

local w, h = term.getSize()
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)
term.setCursorBlink(true)

scrollLines()
printCenterWrapped("FATAL ERROR", w)
scrollLines()
printCenterWrapped("A critical error has occured and Radium cannot continue running", w)
scrollLines()
printCenterWrapped("The error code is as follows", w)

scrollLines()
term.setTextColor(colors.red)
printCenterWrapped(err, w)
term.setTextColor(colors.white)

scrollLines()
printCenterWrapped("Press 'c' to enter CraftOS shell or any other key to shutdown:", w)
scrollLines(-1)

local _, c = os.pullEvent("char")
if c == "c" or c == "C" then
	print(c)

	local f = fs.open("rom/programs/shell", "r")
	local d = f.readAll()
	f.close()

	local f, e = load(d, "shell", nil, _ENV)

	if f then
		local ok, er = f()
		if not ok then e = er end
	end

	if e then
		printError("An error occured while recovering from an error in an error handler. System shutting down in 10 seconds.")
		sleep(10)
	end
	os.shutdown()
else
	os.shutdown()
end