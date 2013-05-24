--LuaCC
--It's recommended to be an intermediare scripter to change values from here
require'LuaMinify'
FileExtension = ".luacc" -- Change it with your own file extension 

local LuaCCDecode = function(Code)
	assert(Code, "The code must be a non-nil value")
	assert(type(Code) == "string", "Attempt to compile a non-string value")
	
	Classes = {
	   bool = function(x)
	      return x ~= nil and x ~= false
	   end;
	   int = function(x)
		  return math.floor((tonumber(x) or 0) + 0.5)
	   end;
	   string = tostring;
	};
	local Combine = {
	   -- Lua
	   "%d+%.%d+";
	   -- Compiler
	   "=="; "~="; ">="; "<="; "%+="; "%-="; "%*="; "%/="; "%.="; "%+%+"; "%-%-";
	   -- Pre compiler
	   "[_%w]+"; "%p";
	};
		
	--Change the values down here
	local Syntax = {
	   ["if"] = "if";
    	   ["function"] = "function";
	   ["do"] = "do";
	   ["then"] = "then";
	   ["while"] = "while";
	   ["nil"] = "nil";
	   ["not"] = "not";
	   ["and"] = "and";
	   ["or"] = "or";
	   ["local"] = "local";
	   ["_G."] = "_G.";
	   ["true"] = "true";
	   ["false"] = "false";
	   ["break"] = "break";
	   ["else"] = "else";
	   ["elseif"] = "elseif";
	   ["for"] = "for";
	   ["repeat"] = "repeat";
	   ["return"] = "return";
	   ["require"] = "require";
	   ["in"] = "in";
	   ["until"] = "until";
	   ["print"] = "print";
	   ["assert"] = "assert";
	}
	local Types = {
	   ["string"] = true;
	   ["number"] = true;
	   ["table"] = true;
	   ["function"] = true;
	   ["userdata"] = true;
	};
	local CaseSensitive = true
	local UnaryOperators = true
	local AgumentedOperators = true
	local VariableClasses = true
	local Minify = false
        local StringOperators = true
						
	local BuiltIn = [[  ]]
						
	local Replace = {
		["_VERSION"] = "1.0";
	};
	local Ignore = {
		{Start = "'", End = "'", Compile = true};
		{Start = "\"", End = "\"", Compile = true};
		{Start = "/*", End = "*/", Compile = false};
		{Start = "//", End = string.char(10), Compile = false}
	}
						
	--Here you can stop editing ^_^
	local preCompiled = {}
        local Strings = [[ local function argCheck(var, t, argNum, funcName)
   assert(type(var) == t, "bad argument #"..argNum.." to "..funcName.." ("..t.." expected, got "..type(var)..")");
end

-- Concatenation: s1 + s2 = s1..s2
getmetatable("").__add = function (s1, s2)
   argCheck(s1, "string", 1, "string addition");
   argCheck(s2, "string", 2, "string addition");
   return tostring(s1)..tostring(s2);
end

-- Gsub: s1 - s2 = s1:gsub(s2, "");
getmetatable("").__sub = function (s1, s2)
   argCheck(s1, "string", 1, "string subtraction");
   argCheck(s2, "string", 2, "string subtraction");
   return string.gsub(tostring(s1), tostring(s2), "");
end

-- Repititon: "x" * y = ("x"):rep(y);
-- If y is negative then reverses string
-- "Hello" * -2 = "olleHolleH"
getmetatable("").__mul = function (s, t)
   if type(s)== "string" and type(t)== "number" then
      argCheck(s, "string", 1, "string multiplication");
      argCheck(t, "number", 2, "string multiplication");
      s = s
      t = tonumber(t);
   elseif type(t) == "string" and type(s)== "number" then
      argCheck(t, "string", 1, "string multiplication");
      argCheck(s, "number", 2, "string multiplication");
      newt = t
      t = s
      s = newt
   end
   local s2 = tostring(s):rep(math.abs(t));
   if (t < 0) then
      s2 = s2:reverse();
   end
   return tostring(s2);
end

-- Split into a table: "Hello World" / " " = {"Hello", "World"}
getmetatable("").__div = function (str, split)
   argCheck(str, "string", 1, "string division");
   argCheck(split, "string", 2, "string division");
local tbl = { };
str = tostring(str)..tostring(split);
for s in str:gmatch("(.-)"..split) do
   tbl[#tbl + 1] = s;
end
return tbl;
end

-- Reverses: -"Hello" = "olleH"
getmetatable("").__unm = function (str)
argCheck(str, "string", 1, "string negation");
return tostring(str) * -1;
end

-- String slicing (like Python):
-- stringVariable("start:finish:increment")
-- Or normal string.sub calling without increment
getmetatable("").__call = function (str, ...)
argCheck(str, "string", 1, "string slicing call");
str = tostring(str);
local slices = {...};
local doSlicing = function (start, finish, inc)
if (inc == 1) then
   return str:sub(start, finish);
else
   if (inc < 0) then
      start, finish = finish, start;
   end
   local s = "";
   for i = start, finish, inc do
      s = s..str:sub(i, i);
   end
   return s;
end
end
if (#slices == 1) then
if (type(slices[1]) == "number") then
   return str:sub(slices[1], slices[1]);
elseif (type(slices[1]) == "string") then
   local start, finish, inc = slices[1]:match("(%-?%d*):?(%-?%d*):?(%-?%d*)");
   return doSlicing((start == "") and 1 or tonumber(start),
   (finish == "") and #str or tonumber(finish),
   (inc == "") and 1 or tonumber(inc));
end
elseif (#slices == 2) then
return str:sub(slices[1], slices[2]);
elseif (#slices == 3) then
return doSlicing(unpack(slices));
end
end

-- "My string is %lol" % {lol = "yay"}
getmetatable("").__mod = function (str, tbl)
argCheck(str, "string", 1, "string interpolation");
argCheck(tbl, "table", 2, "string interpolation");
return tostring(str):gsub("%%([%w_]+)", function (v)
if (tbl[v]) then
   return tbl[v];
end
end);
end
]]
						
	-- Pre compile
	while Code:len() > 0 do
		local Break = false
		local Len = Code:len()
							
		-- Ignore
		for _, Data in pairs(Ignore) do
			if Code:sub(1, Data.Start:len()) == Data.Start then
			   local End = Code:sub(1 + Data.Start:len()):find(Data.End)
			   if Data.Compile then
			      preCompiled[#preCompiled + 1] = Code:sub(1, End + Data.End:len())
			   end
			   Code = Code:sub(End + Data.End:len() + 1)
			   break
			end
		end
							
		-- Combine
		for _, Combo in pairs(Combine) do
			for i = Len, 1, -1 do
				if Code:sub(1, i):match(Combo) == Code:sub(1, i) then
					preCompiled[#preCompiled + 1] = Code:sub(1, i)
					Code = Code:sub(i + 1)
					Break = true
					break
				end
			end
			if Break then
				break
			end
		end
							
		-- Replace
		if preCompiled[#preCompiled] then
		   for Replace, With in pairs(Replace) do
		   		if preCompiled[#preCompiled]:match(Replace) == preCompiled[#preCompiled] then
		  			preCompiled[#preCompiled] = With
		   			break
				end
			end
		end
							
		-- Crash preventor
		if Len == Code:len() then
			Code = Code:sub(2)
		end
	end
						
	-- Variables
	local Compiled = ""
	local isClass = false
	local isFunc = false
	local isThen = false
	local isDo = false
	local explicitPar = {}
	local Parameters = {}
						
						
	-- Compile
	for i, l in pairs(preCompiled) do
		Compiled = Compiled .. " "
		if l then
		
		for n,v in pairs(Syntax) do
			if l == n and n~= v then error("An error have occured while compiling") end --Anti-Lua Syntax
			if CaseSensitive == false then l = l:lower() v = v:lower() end
			if l == v then
			   if n == Syntax["function"] then
			   		isFunc = true
		   	   elseif n == Syntax["while"] or n == Syntax["for"] then
		   			isDo = true
	   	 	   elseif n == Syntax["if"] or n == Syntax["elseif"] or n == Syntax["else"] then
	   	   			isThen = true
			   end	
			   l = n
			end
		end	
											
											
		-- Augmented assignment operators
		if l == "+=" and AgumentedOperators or l == "-=" and AgumentedOperators or l == "*=" and AgumentedOperators or l == "/=" and AgumentedOperators or l == ".=" and AgumentedOperators then
			for j = 1, Compiled:len() do
				if loadstring("x=(" .. Compiled:sub(j) .. ")") then
					local Operator = l == ".=" and ".." or l:sub(1, 1)
					Compiled = Compiled:sub(1, j - 1) .. Compiled:sub(j) .. " = " .. Compiled:sub(j) .. " " .. Operator
					break
				end
			end
											
		-- Unary operators
		elseif l == "++" and UnaryOperators or l == "--" and UnaryOperators then
			for j = 1, Compiled:len() do
				if loadstring("x=(" .. Compiled:sub(j) .. ")") then
					Compiled = Compiled:sub(1, j - 1) .. Compiled:sub(j) .. " = " .. Compiled:sub(j) .. " " .. l:sub(1, 1) .. " 1"
					break
				end
			end
											
		-- Specific classes
		elseif l == ":" and VariableClasses then
			for j = 1, Compiled:len() do
				if loadstring("x=(" .. Compiled:sub(j) .. ")") then
					Compiled = Compiled:sub(1, j - 1) .. " Classes." .. preCompiled[i + 1] .. "(" .. Compiled:sub(j) .. ")"
					preCompiled[i + 1] = nil
					break
				end
			end
											
		-- Default function parameters
		elseif l == "=" and isFunc then
			for j = #preCompiled, i, -1 do
				local xCompiled = ""
				for k = i + 1, j do
					xCompiled = xCompiled .. preCompiled[k] .. " "
				end
				if loadstring("x=(" .. xCompiled .. ")") then
					for k = i, j do
						preCompiled[k] = nil
					end
					Parameters[preCompiled[i - 1]] = xCompiled
					break
				end
			end
												
		-- Explicit parameter classes
		elseif Types[l] and isFunc then
			explicitPar[preCompiled[i + 1]] = l
									
		-- Everything else
		else
			Compiled = Compiled .. l
			
		end
		end
	end

	-- Run script
	Compiled = BuiltIn..Compiled
        if StringOperators then Compiled = Strings..Compiled end
	local Func, Error = loadstring(Compiled)
	if Func then
		if CaseSensitive == true then
			
		elseif CaseSensitive == false then
			Compiled = Compiled:lower()
			Compiled = "_version = _VERSION"..Compiled
		end
		if Minify == true then
			_,minified = LuaMinify(Compiled)
		else
			minified = Compiled
		end
		return minified
	else
		return Compiled, error("An error have occured while compiling")
	end
end
											
LuaCC = {
	Compile = function(file,name )
		assert(file, "The code must be a non-nil value")
		assert(type(file) == "string", "Attempt to compile a non-string value")
		assert(string.find(file,FileExtension), "Attempt to compile another type of file")
		x = io.open(file)
		code = x:read("*all")
		x:close()
		filename = name or "Example"
		if string.find(filename,".lua") == nil then extension = false else extension = true end
		if extension == true then
			newfilename = filename
		else
			newfilename = filename..".lua"
		end
		newfile=io.open(newfilename, "w+")
		newfile:write(LuaCCDecode(code))
		newfile:close()
	end;
											
	Execute = function(file)
		assert(file, "The code must be a non-nil value")
		assert(type(file) == "string", "Attempt to compile a non-string value")
		assert(string.find(file,FileExtension), "Attempt to execute another type of file")
		x = io.open(file)
		code = x:read("*all")
		x:close()
		loadstring(LuaCCDecode(code))()
	end;
											
	Run = function(Code)
		loadstring(LuaCCDecode(Code))()
	end;
}
mt = {__metatable = true}
setmetatable(LuaCC,mt)

return LuaCC
