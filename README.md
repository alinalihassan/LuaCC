LuaCC
=====
-------

- LuaCC is a lightweight lua compiler compiler/ parse generator for Lua, a lightweight C derived language;
- LuaCC is WIP ( Work In Progress);
- LuaCC work just with Lua 5.1+;

Features
--------

- LuaCC languages can be compiled to Lua or executed.
- Math unary operators and augmented assignment operators (OPTIONAL).
- Variable classes:int, bool, string (OPTIONAL).
- You can customize your own syntax very easy.
- LuaCC is the most lightweight parse generator, under 300 lines with comments.
- LuaCC is also the single parse generator for Lua.
- You can compile your own language files to .lua using CLua.Compile function.
- You can execute your language files using LuaCC.Execute.
- You can use your own langauge into a .lua file using the CLua.Run function.
- You decide if your language is case sensitive or not (All characters are lower).
- You can replace Lua variables or functions using the Replace table.
- You can decide if the .lua code is minified or not <Performance vs Readable>.

The API
--------

    LuaCC = require "LuaCC"
    LuaCC.Run(CODE) -- you can use it in a .lua file
    LuaCC.Execute(FILE) -- you can execute .clua files
    LuaCC.Compile(FILE,NEWFILE) -- you can turn your own language files into .lua files, for overwrite use the same string for FILE and NEWFILE
