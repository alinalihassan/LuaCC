--LuaCC
--It's recommended to be an intermediare scripter to change values from here
--Change with your file extension at LuaCC.Compile and LuaCC.Execute at string.find(file, ".luacc")
require'LuaMinify'
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
	   ["IF"] = "if",
       ["FUNCTION"] = "function",
	   ["DO"] = "do",
	   ["THEN"] = "then",
	   ["WHILE"] = "while",
	   ["NIL"] = "nil",
	   ["NOT"] = "not",
	   ["AND"] = "and",
	   ["OR"] = "or",
	   ["LOCAL"] = "local",
	   ["TRUE"] = "true",
	   ["FALSE"] = "false",
	   ["BREAK"] = "break",
	   ["ELSE"] = "else",
	   ["ELSEIF"] = "elseif",
	   ["FOR"] = "for",
	   ["REPEAT"] = "repeat",
	   ["RETURN"] = "return",
	   ["REQUIRE"] = "require",
	   ["IN"] = "in",
	   ["UNTIL"] = "until";
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
		if not l then
			
		elseif l == Syntax.FUNCTION then
			l = "function"
			isFunc = true
			Compiled = Compiled .. l
		elseif l == Syntax.IF then
			l = "if"
			isThen = true
			Compiled = Compiled .. l
		elseif l == Syntax.FOR then
			l = "for"
			isDo = true
			Compiled = Compiled .. l
		elseif l == Syntax.DO then
			l = "do"
			Compiled = Compiled .. l
		elseif l == Syntax.THEN then
			l = "then"
			Compiled = Compiled .. l
		elseif l == Syntax.WHILE then
			l = "while"
			Compiled = Compiled .. l
		elseif l == Syntax.NIL then
			l = "nil"
			Compiled = Compiled .. l
		elseif l == Syntax.NOT then
			l = "not"
			Compiled = Compiled .. l
		elseif l == Syntax.AND then
			l = "and"
			Compiled = Compiled .. l
		elseif l == Syntax.OR then
			l = "or"
			Compiled = Compiled .. l
		elseif l == Syntax.LOCAL then
			l = "local"
			Compiled = Compiled .. l
		elseif l == Syntax.TRUE then
			l = "true"
			Compiled = Compiled .. l
		elseif l == Syntax.FALSE then
			l = "false"
			Compiled = Compiled .. l
		elseif l == Syntax.BREAK then
			l = "break"
			Compiled = Compiled .. l
		elseif l == Syntax.ELSE then
			l = "else"
			Compiled = Compiled .. l				
		elseif l == Syntax.ELSEIF then
			l = "elseif"
			Compiled = Compiled .. l
		elseif l == Syntax.REPEAT then
			l = "repeat"
			Compiled = Compiled .. l				
		elseif l == Syntax.RETURN then
			l = "return"
			Compiled = Compiled .. l
		elseif l == Syntax.IN then
			l = "in"
			Compiled = Compiled .. l
		elseif l == Syntax.REQUIRE then
			l = "require"
			Compiled = Compiled .. l
		elseif l == Syntax.UNTIL then
			l = "until"
			Compiled = Compiled .. l
										
											
											
		-- Augmented assignment operators
		elseif l == "+=" and AgumentedOperators or l == "-=" and AgumentedOperators or l == "*=" and AgumentedOperators or l == "/=" and AgumentedOperators or l == ".=" and AgumentedOperators then
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
					Compiled = Compiled:sub(1, j - 1) .. "Classes." .. preCompiled[i + 1] .. "(" .. Compiled:sub(j) .. ")"
					preCompiled[i + 1] = nil
					break
				end
			end
											
		-- Default function parameters
		elseif l == "=" and isFunc then
			for j = #preCompiled, i, -1 do
				local xCompiled = ""
				for k = i + 1, j do
					if preCompiled[k] == "{" then break end
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
		return minified, print("The code have been succesfully compiled")
	else
		return Compiled, error("An error have occured!")
	end
end
											
LuaCC = {
	Compile = function(file,name )
		assert(file, "The code must be a non-nil value")
		assert(type(file) == "string", "Attempt to compile a non-string value")
		assert(string.find(file,".luacc"), "Attempt to compile another type of file")
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
		assert(string.find(file,".luacc"), "Attempt to execute another type of file")
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
