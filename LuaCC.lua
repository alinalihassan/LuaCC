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
