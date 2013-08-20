--[[Lua Minify]]local function a(b)for c,d in pairs(b)do b[d]=true end;return b end;local function e(b)local f=0;for c in pairs(b)do f=f+1 end;return f end;local function g(b,h)if b.Print then return b.Print()end;h=h or 0;local i=e(b)>1;local j=string.rep('    ',h+1)local k="{"..i and'\n'or''for l,d in pairs(b)do if type(d)~='function'then k=k..i and j or''if type(l)=='number'then elseif type(l)=='string'and l:match("^[A-Za-z_][A-Za-z0-9_]*$")then k=k..l.." = "elseif type(l)=='string'then k=k.."[\""..l.."\"] = "else k=k.."["..tostring(l).."] = "end;if type(d)=='string'then k=k.."\""..d.."\""elseif type(d)=='number'then k=k..d elseif type(d)=='table'then k=k..g(d,h+i and 1 or 0)else k=k..tostring(d)end;if next(b,l)then k=k..","end;if i then k=k..'\n'end end end;k=k..(i and string.rep('    ',h)or'').."}"return k end;local m=a{' ','\n','\t','\r'}local n={['\r']='\\r',['\n']='\\n',['\t']='\\t',['"']='\\"',["'"]="\\'"}local o=a{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}local p=a{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}local q=a{'0','1','2','3','4','5','6','7','8','9'}local r=a{'0','1','2','3','4','5','6','7','8','9','A','a','B','b','C','c','D','d','E','e','F','f'}local s=a{'+','-','*','/','^','%',',','{','}','[',']','(',')',';','#'}local t=a{'and','break','do','else','elseif','end','false','for','function','goto','if','in','local','nil','not','or','repeat','return','then','true','until','while'}local function u(v)local w={}local x,y=pcall(function()local z=1;local A=1;local B=1;local function C()local f=v:sub(z,z)if f=='\n'then B=1;A=A+1 else B=B+1 end;z=z+1;return f end;local function D(E)E=E or 0;return v:sub(z+E,z+E)end;local function F(G)local f=D()for H=1,#G do if f==G:sub(H,H)then return C()end end end;local function I(y)return error(">> :"..A..":"..B..": "..y,0)end;local function J()local K=z;if D()=='['then local L=0;while D(L+1)=='='do L=L+1 end;if D(L+1)=='['then for c=0,L+1 do C()end;local M=z;while true do if D()==''then I("Expected `]"..string.rep('=',L).."]` near <eof>.",3)end;local N=true;if D()==']'then for H=1,L do if D(H)~='='then N=false end end;if D(L+1)~=']'then N=false end else N=false end;if N then break else C()end end;local O=v:sub(M,z-1)for H=0,L+1 do C()end;local P=v:sub(K,z-1)return O,P else return nil end else return nil end end;while true do local Q=''while true do local f=D()if m[f]then Q=Q..C()elseif f=='-'and D(1)=='-'then C()C()Q=Q..'--'local c,R=J()if R then Q=Q..R else while D()~='\n'and D()~=''do Q=Q..C()end end else break end end;local S=A;local T=B;local U=":"..A..":"..B..":> "local f=D()local V=nil;if f==''then V={Type='Eof'}elseif p[f]or o[f]or f=='_'then local K=z;repeat C()f=D()until not(p[f]or o[f]or q[f]or f=='_')local W=v:sub(K,z-1)if t[W]then V={Type='Keyword',Data=W}else V={Type='Ident',Data=W}end elseif q[f]or D()=='.'and q[D(1)]then local K=z;if f=='0'and D(1)=='x'then C()C()while r[D()]do C()end;if F('Pp')then F('+-')while q[D()]do C()end end else while q[D()]do C()end;if F('.')then while q[D()]do C()end end;if F('Ee')then F('+-')while q[D()]do C()end end end;V={Type='Number',Data=v:sub(K,z-1)}elseif f=='\''or f=='\"'then local K=z;local X=C()local M=z;while true do local f=C()if f=='\\'then C()elseif f==X then break elseif f==''then I("Unfinished string near <eof>")end end;local Y=v:sub(M,z-2)local Z=v:sub(K,z-1)V={Type='String',Data=Z,Constant=Y}elseif f=='['then local Y,_=J()if _ then V={Type='String',Data=_,Constant=Y}else C()V={Type='Symbol',Data='['}end elseif F('>=<')then if F('=')then V={Type='Symbol',Data=f..'='}else V={Type='Symbol',Data=f}end elseif F('~')then if F('=')then V={Type='Symbol',Data='~='}else I("Unexpected symbol `~` in source.",2)end elseif F('.')then if F('.')then if F('.')then V={Type='Symbol',Data='...'}else V={Type='Symbol',Data='..'}end else V={Type='Symbol',Data='.'}end elseif F(':')then if F(':')then V={Type='Symbol',Data='::'}else V={Type='Symbol',Data=':'}end elseif s[f]then C()V={Type='Symbol',Data=f}else local a0,a1=J()if a0 then V={Type='String',Data=a1,Constant=a0}else I("Unexpected Symbol `"..f.."` in source.",2)end end;V.LeadingWhite=Q;V.Line=S;V.Char=T;V.Print=function()return"<"..(V.Type..string.rep(' ',7-#V.Type)).."  "..(V.Data or'').." >"end;w[#w+1]=V;if V.Type=='Eof'then break end end end)if not x then return false,y end;local tok={}local a2={}local z=1;function tok:Peek(E)E=E or 0;return w[math.min(#w,z+E)]end;function tok:Get()local a3=w[z]z=math.min(z+1,#w)return a3 end;function tok:Is(a3)return tok:Peek().Type==a3 end;function tok:Save()a2[#a2+1]=z end;function tok:Commit()a2[#a2]=nil end;function tok:Restore()z=a2[#a2]a2[#a2]=nil end;function tok:ConsumeSymbol(a4)local a3=self:Peek()if a3.Type=='Symbol'then if a4 then if a3.Data==a4 then self:Get()return true else return nil end else self:Get()return a3 end else return nil end end;function tok:ConsumeKeyword(a5)local a3=self:Peek()if a3.Type=='Keyword'and a3.Data==a5 then self:Get()return true else return nil end end;function tok:IsKeyword(a5)local a3=tok:Peek()return a3.Type=='Keyword'and a3.Data==a5 end;function tok:IsSymbol(a6)local a3=tok:Peek()return a3.Type=='Symbol'and a3.Data==a6 end;function tok:IsEof()return tok:Peek().Type=='Eof'end;return true,tok end;local function a7(v)local x,tok=u(v)if not x then return false,tok end;local function a8(a9)local y=">> :"..tok:Peek().Line..":"..tok:Peek().Char..": "..a9 .."\n"local aa=0;for A in v:gmatch("[^\n]*\n?")do if A:sub(-1,-1)=='\n'then A=A:sub(1,-2)end;aa=aa+1;if aa==tok:Peek().Line then y=y..">> `"..A:gsub('\t','    ').."`\n"for H=1,tok:Peek().Char do local f=A:sub(H,H)if f=='\t'then y=y..'    'else y=y..' 'end end;y=y.."   ^---"break end end;return y end;local ab=0;local ac={}local ad={'_','a','b','c','d'}local function ae(af)local scope={}scope.Parent=af;scope.LocalList={}scope.LocalMap={}function scope:RenameVars()for c,ag in pairs(scope.LocalList)do local ah;ab=0;repeat ab=ab+1;local ai=ab;ah=''while ai>0 do local aj=ai%#ad;ai=(ai-aj)/#ad;ah=ah..ad[aj+1]end until not ac[ah]and not af:GetLocal(ah)and not scope.LocalMap[ah]ag.Name=ah;scope.LocalMap[ah]=ag end end;function scope:GetLocal(ak)local al=scope.LocalMap[ak]if al then return al end;if scope.Parent then local am=scope.Parent:GetLocal(ak)if am then return am end end;return nil end;function scope:CreateLocal(ak)local al={}al.Scope=scope;al.Name=ak;al.CanRename=true;scope.LocalList[#scope.LocalList+1]=al;scope.LocalMap[ak]=al;return al end;scope.Print=function()return"<Scope>"end;return scope end;local an;local ao;local function ap(scope)local aq=ae(scope)if not tok:ConsumeSymbol('(')then return false,a8("`(` expected.")end;local ar={}local as=false;while not tok:ConsumeSymbol(')')do if tok:Is('Ident')then local at=aq:CreateLocal(tok:Get().Data)ar[#ar+1]=at;if not tok:ConsumeSymbol(',')then if tok:ConsumeSymbol(')')then break else return false,a8("`)` expected.")end end elseif tok:ConsumeSymbol('...')then as=true;if not tok:ConsumeSymbol(')')then return false,a8("`...` must be the last argument of a function.")end;break else return false,a8("Argument name or `...` expected")end end;local x,au=ao(aq)if not x then return false,au end;if not tok:ConsumeKeyword('end')then return false,a8("`end` expected after function body")end;local av={}av.AstType='Function'av.Scope=aq;av.Arguments=ar;av.Body=au;av.VarArg=as;return true,av end;local function aw(scope)if tok:ConsumeSymbol('(')then local x,ax=an(scope)if not x then return false,ax end;if not tok:ConsumeSymbol(')')then return false,a8("`)` Expected.")end;ax.ParenCount=(ax.ParenCount or 0)+1;return true,ax elseif tok:Is('Ident')then local ah=tok:Get()local ag=scope:GetLocal(ah.Data)if not ag then ac[ah.Data]=true end;local ay={}ay.AstType='VarExpr'ay.Name=ah.Data;ay.Local=ag;return true,ay else return false,a8("primary expression expected")end end;local function az(scope,aA)local x,aB=aw(scope)if not x then return false,aB end;while true do if tok:IsSymbol('.')or tok:IsSymbol(':')then local a4=tok:Get().Data;if not tok:Is('Ident')then return false,a8("<Ident> expected.")end;local ah=tok:Get()local aC={}aC.AstType='MemberExpr'aC.Base=aB;aC.Indexer=a4;aC.Ident=ah;aB=aC elseif not aA and tok:ConsumeSymbol('[')then local x,ax=an(scope)if not x then return false,ax end;if not tok:ConsumeSymbol(']')then return false,a8("`]` expected.")end;local aC={}aC.AstType='IndexExpr'aC.Base=aB;aC.Index=ax;aB=aC elseif not aA and tok:ConsumeSymbol('(')then local aD={}while not tok:ConsumeSymbol(')')do local x,ax=an(scope)if not x then return false,ax end;aD[#aD+1]=ax;if not tok:ConsumeSymbol(',')then if tok:ConsumeSymbol(')')then break else return false,a8("`)` Expected.")end end end;local aE={}aE.AstType='CallExpr'aE.Base=aB;aE.Arguments=aD;aB=aE elseif not aA and tok:Is('String')then local aE={}aE.AstType='StringCallExpr'aE.Base=aB;aE.Arguments={tok:Get()}aB=aE elseif not aA and tok:IsSymbol('{')then local x,ax=an(scope)if not x then return false,ax end;local aE={}aE.AstType='TableCallExpr'aE.Base=aB;aE.Arguments={ax}aB=aE else break end end;return true,aB end;local function aF(scope)if tok:Is('Number')then local aG={}aG.AstType='NumberExpr'aG.Value=tok:Get()return true,aG elseif tok:Is('String')then local aH={}aH.AstType='StringExpr'aH.Value=tok:Get()return true,aH elseif tok:ConsumeKeyword('nil')then local aI={}aI.AstType='NilExpr'return true,aI elseif tok:IsKeyword('false')or tok:IsKeyword('true')then local aJ={}aJ.AstType='BooleanExpr'aJ.Value=tok:Get().Data=='true'return true,aJ elseif tok:ConsumeSymbol('...')then local aK={}aK.AstType='DotsExpr'return true,aK elseif tok:ConsumeSymbol('{')then local d={}d.AstType='ConstructorExpr'd.EntryList={}while true do if tok:IsSymbol('[')then tok:Get()local x,aL=an(scope)if not x then return false,a8("Key Expression Expected")end;if not tok:ConsumeSymbol(']')then return false,a8("`]` Expected")end;if not tok:ConsumeSymbol('=')then return false,a8("`=` Expected")end;local x,aM=an(scope)if not x then return false,a8("Value Expression Expected")end;d.EntryList[#d.EntryList+1]={Type='Key',Key=aL,Value=aM}elseif tok:Is('Ident')then local aN=tok:Peek(1)if aN.Type=='Symbol'and aN.Data=='='then local aL=tok:Get()if not tok:ConsumeSymbol('=')then return false,a8("`=` Expected")end;local x,aM=an(scope)if not x then return false,a8("Value Expression Expected")end;d.EntryList[#d.EntryList+1]={Type='KeyString',Key=aL.Data,Value=aM}else local x,aM=an(scope)if not x then return false,a8("Value Exected")end;d.EntryList[#d.EntryList+1]={Type='Value',Value=aM}end elseif tok:ConsumeSymbol('}')then break else local x,aM=an(scope)d.EntryList[#d.EntryList+1]={Type='Value',Value=aM}if not x then return false,a8("Value Expected")end end;if tok:ConsumeSymbol(';')or tok:ConsumeSymbol(',')then elseif tok:ConsumeSymbol('}')then break else return false,a8("`}` or table entry Expected")end end;return true,d elseif tok:ConsumeKeyword('function')then local x,aO=ap(scope)if not x then return false,aO end;aO.IsLocal=true;return true,aO else return az(scope)end end;local aP=a{'-','not','#'}local aQ=8;local aR={['+']={6,6},['-']={6,6},['%']={7,7},['/']={7,7},['*']={7,7},['^']={10,9},['..']={5,4},['==']={3,3},['<']={3,3},['<=']={3,3},['~=']={3,3},['>']={3,3},['>=']={3,3},['and']={2,2},['or']={1,1}}local function aS(scope,aT)local x,aU;if aP[tok:Peek().Data]then local aV=tok:Get().Data;x,aU=aS(scope,aQ)if not x then return false,aU end;local aW={}aW.AstType='UnopExpr'aW.Rhs=aU;aW.Op=aV;aU=aW else x,aU=aF(scope)if not x then return false,aU end end;while true do local aX=aR[tok:Peek().Data]if aX and aX[1]>aT then local aV=tok:Get().Data;local x,aY=aS(scope,aX[2])if not x then return false,aY end;local aW={}aW.AstType='BinopExpr'aW.Lhs=aU;aW.Op=aV;aW.Rhs=aY;aU=aW else break end end;return true,aU end;an=function(scope)return aS(scope,0)end;local function aZ(scope)local a_=nil;if tok:ConsumeKeyword('if')then local b0={}b0.AstType='IfStatement'b0.Clauses={}repeat local x,b1=an(scope)if not x then return false,b1 end;if not tok:ConsumeKeyword('then')then return false,a8("`then` expected.")end;local x,b2=ao(scope)if not x then return false,b2 end;b0.Clauses[#b0.Clauses+1]={Condition=b1,Body=b2}until not tok:ConsumeKeyword('elseif')if tok:ConsumeKeyword('else')then local x,b2=ao(scope)if not x then return false,b2 end;b0.Clauses[#b0.Clauses+1]={Body=b2}end;if not tok:ConsumeKeyword('end')then return false,a8("`end` expected.")end;a_=b0 elseif tok:ConsumeKeyword('while')then local b3={}b3.AstType='WhileStatement'local x,b1=an(scope)if not x then return false,b1 end;if not tok:ConsumeKeyword('do')then return false,a8("`do` expected.")end;local x,b2=ao(scope)if not x then return false,b2 end;if not tok:ConsumeKeyword('end')then return false,a8("`end` expected.")end;b3.Condition=b1;b3.Body=b2;a_=b3 elseif tok:ConsumeKeyword('do')then local x,b4=ao(scope)if not x then return false,b4 end;if not tok:ConsumeKeyword('end')then return false,a8("`end` expected.")end;local b5={}b5.AstType='DoStatement'b5.Body=b4;a_=b5 elseif tok:ConsumeKeyword('for')then if not tok:Is('Ident')then return false,a8("<ident> expected.")end;local b6=tok:Get()if tok:ConsumeSymbol('=')then local b7=ae(scope)local b8=b7:CreateLocal(b6.Data)local x,b9=an(scope)if not x then return false,b9 end;if not tok:ConsumeSymbol(',')then return false,a8("`,` Expected")end;local x,ba=an(scope)if not x then return false,ba end;local x,bb;if tok:ConsumeSymbol(',')then x,bb=an(scope)if not x then return false,bb end end;if not tok:ConsumeKeyword('do')then return false,a8("`do` expected")end;local x,au=ao(b7)if not x then return false,au end;if not tok:ConsumeKeyword('end')then return false,a8("`end` expected")end;local bc={}bc.AstType='NumericForStatement'bc.Scope=b7;bc.Variable=b8;bc.Start=b9;bc.End=ba;bc.Step=bb;bc.Body=au;a_=bc else local b7=ae(scope)local bd={b7:CreateLocal(b6.Data)}while tok:ConsumeSymbol(',')do if not tok:Is('Ident')then return false,a8("for variable expected.")end;bd[#bd+1]=b7:CreateLocal(tok:Get().Data)end;if not tok:ConsumeKeyword('in')then return false,a8("`in` expected.")end;local be={}local x,bf=an(scope)if not x then return false,bf end;be[#be+1]=bf;while tok:ConsumeSymbol(',')do local x,bg=an(scope)if not x then return false,bg end;be[#be+1]=bg end;if not tok:ConsumeKeyword('do')then return false,a8("`do` expected.")end;local x,au=ao(b7)if not x then return false,au end;if not tok:ConsumeKeyword('end')then return false,a8("`end` expected.")end;local bc={}bc.AstType='GenericForStatement'bc.Scope=b7;bc.VariableList=bd;bc.Generators=be;bc.Body=au;a_=bc end elseif tok:ConsumeKeyword('repeat')then local x,au=ao(scope)if not x then return false,au end;if not tok:ConsumeKeyword('until')then return false,a8("`until` expected.")end;local x,bh=an(scope)if not x then return false,bh end;local bi={}bi.AstType='RepeatStatement'bi.Condition=bh;bi.Body=au;a_=bi elseif tok:ConsumeKeyword('function')then if not tok:Is('Ident')then return false,a8("Function name expected")end;local x,ak=az(scope,true)if not x then return false,ak end;local x,aO=ap(scope)if not x then return false,aO end;aO.IsLocal=false;aO.Name=ak;a_=aO elseif tok:ConsumeKeyword('local')then if tok:Is('Ident')then local bd={tok:Get().Data}while tok:ConsumeSymbol(',')do if not tok:Is('Ident')then return false,a8("local var name expected")end;bd[#bd+1]=tok:Get().Data end;local bj={}if tok:ConsumeSymbol('=')then repeat local x,ax=an(scope)if not x then return false,ax end;bj[#bj+1]=ax until not tok:ConsumeSymbol(',')end;for H,d in pairs(bd)do bd[H]=scope:CreateLocal(d)end;local bk={}bk.AstType='LocalStatement'bk.LocalList=bd;bk.InitList=bj;a_=bk elseif tok:ConsumeKeyword('function')then if not tok:Is('Ident')then return false,a8("Function name expected")end;local ak=tok:Get().Data;local bl=scope:CreateLocal(ak)local x,aO=ap(scope)if not x then return false,aO end;aO.Name=bl;aO.IsLocal=true;a_=aO else return false,a8("local var or function def expected")end elseif tok:ConsumeSymbol('::')then if not tok:Is('Ident')then return false,a8('Label name expected')end;local bm=tok:Get().Data;if not tok:ConsumeSymbol('::')then return false,a8("`::` expected")end;local bn={}bn.AstType='LabelStatement'bn.Label=bm;a_=bn elseif tok:ConsumeKeyword('return')then local bo={}if not tok:IsKeyword('end')then local x,bp=an(scope)if x then bo[1]=bp;while tok:ConsumeSymbol(',')do local x,ax=an(scope)if not x then return false,ax end;bo[#bo+1]=ax end end end;local bq={}bq.AstType='ReturnStatement'bq.Arguments=bo;a_=bq elseif tok:ConsumeKeyword('break')then local br={}br.AstType='BreakStatement'a_=br elseif tok:IsKeyword('goto')then if not tok:Is('Ident')then return false,a8("Label expected")end;local bm=tok:Get().Data;local bs={}bs.AstType='GotoStatement'bs.Label=bm;a_=bs else local x,bt=az(scope)if not x then return false,bt end;if tok:IsSymbol(',')or tok:IsSymbol('=')then if(bt.ParenCount or 0)>0 then return false,a8("Can not assign to parenthesized expression, is not an lvalue")end;local bu={bt}while tok:ConsumeSymbol(',')do local x,bv=az(scope)if not x then return false,bv end;bu[#bu+1]=bv end;if not tok:ConsumeSymbol('=')then return false,a8("`=` Expected.")end;local aY={}local x,bw=an(scope)if not x then return false,bw end;aY[1]=bw;while tok:ConsumeSymbol(',')do local x,bx=an(scope)if not x then return false,bx end;aY[#aY+1]=bx end;local by={}by.AstType='AssignmentStatement'by.Lhs=bu;by.Rhs=aY;a_=by elseif bt.AstType=='CallExpr'or bt.AstType=='TableCallExpr'or bt.AstType=='StringCallExpr'then local aE={}aE.AstType='CallStatement'aE.Expression=bt;a_=aE else return false,a8("Assignment Statement Expected")end end;a_.HasSemicolon=tok:ConsumeSymbol(';')return true,a_ end;local bz=a{'end','else','elseif','until'}ao=function(scope)local bA={}bA.Scope=ae(scope)bA.AstType='Statlist'local bB={}while not bz[tok:Peek().Data]and not tok:IsEof()do local x,bC=aZ(bA.Scope)if not x then return false,bC end;bB[#bB+1]=bC end;bA.Body=bB;return true,bA end;local function bD()local bE=ae()return ao(bE)end;local x,bF=bD()return x,bF end;local o=a{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}local p=a{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}local q=a{'0','1','2','3','4','5','6','7','8','9'}local function bG(bH)local bI,bJ;local bK=0;local function bL(bM,bN,bO)if bK>150 then bK=0;return bM.."\n"..bN end;bO=bO or' 'local bP,bQ=bM:sub(-1,-1),bN:sub(1,1)if p[bP]or o[bP]or bP=='_'then if not(p[bQ]or o[bQ]or bQ=='_'or q[bQ])then return bM..bN elseif bQ=='('then print("==============>>>",bP,bQ)return bM..bO..bN else return bM..bO..bN end elseif q[bP]then if bQ=='('then return bM..bN else return bM..bO..bN end elseif bP==''then return bM..bN else if bQ=='('then return bM..bO..bN else return bM..bN end end end;bJ=function(bR)local k=string.rep('(',bR.ParenCount or 0)if bR.AstType=='VarExpr'then if bR.Local then k=k..bR.Local.Name else k=k..bR.Name end elseif bR.AstType=='NumberExpr'then k=k..bR.Value.Data elseif bR.AstType=='StringExpr'then k=k..bR.Value.Data elseif bR.AstType=='BooleanExpr'then k=k..tostring(bR.Value)elseif bR.AstType=='NilExpr'then k=bL(k,"nil")elseif bR.AstType=='BinopExpr'then k=bL(k,bJ(bR.Lhs))k=bL(k,bR.Op)k=bL(k,bJ(bR.Rhs))elseif bR.AstType=='UnopExpr'then k=bL(k,bR.Op)k=bL(k,bJ(bR.Rhs))elseif bR.AstType=='DotsExpr'then k=k.."..."elseif bR.AstType=='CallExpr'then k=k..bJ(bR.Base)k=k.."("for H=1,#bR.Arguments do k=k..bJ(bR.Arguments[H])if H~=#bR.Arguments then k=k..","end end;k=k..")"elseif bR.AstType=='TableCallExpr'then k=k..bJ(bR.Base)k=k..bJ(bR.Arguments[1])elseif bR.AstType=='StringCallExpr'then k=k..bJ(bR.Base)k=k..bR.Arguments[1].Data elseif bR.AstType=='IndexExpr'then k=k..bJ(bR.Base).."["..bJ(bR.Index).."]"elseif bR.AstType=='MemberExpr'then k=k..bJ(bR.Base)..bR.Indexer..bR.Ident.Data elseif bR.AstType=='Function'then bR.Scope:RenameVars()k=k.."function("if#bR.Arguments>0 then for H=1,#bR.Arguments do k=k..bR.Arguments[H].Name;if H~=#bR.Arguments then k=k..","elseif bR.VarArg then k=k..",..."end end elseif bR.VarArg then k=k.."..."end;k=k..")"k=bL(k,bI(bR.Body))k=bL(k,"end")elseif bR.AstType=='ConstructorExpr'then k=k.."{"for H=1,#bR.EntryList do local bS=bR.EntryList[H]if bS.Type=='Key'then k=k.."["..bJ(bS.Key).."]="..bJ(bS.Value)elseif bS.Type=='Value'then k=k..bJ(bS.Value)elseif bS.Type=='KeyString'then k=k..bS.Key.."="..bJ(bS.Value)end;if H~=#bR.EntryList then k=k..","end end;k=k.."}"end;k=k..string.rep(')',bR.ParenCount or 0)bK=bK+#k;return k end;local bT=function(bU)local k=''if bU.AstType=='AssignmentStatement'then for H=1,#bU.Lhs do k=k..bJ(bU.Lhs[H])if H~=#bU.Lhs then k=k..","end end;if#bU.Rhs>0 then k=k.."="for H=1,#bU.Rhs do k=k..bJ(bU.Rhs[H])if H~=#bU.Rhs then k=k..","end end end elseif bU.AstType=='CallStatement'then k=bJ(bU.Expression)elseif bU.AstType=='LocalStatement'then k=k.."local "for H=1,#bU.LocalList do k=k..bU.LocalList[H].Name;if H~=#bU.LocalList then k=k..","end end;if#bU.InitList>0 then k=k.."="for H=1,#bU.InitList do k=k..bJ(bU.InitList[H])if H~=#bU.InitList then k=k..","end end end elseif bU.AstType=='IfStatement'then k=bL("if",bJ(bU.Clauses[1].Condition))k=bL(k,"then")k=bL(k,bI(bU.Clauses[1].Body))for H=2,#bU.Clauses do local x=bU.Clauses[H]if x.Condition then k=bL(k,"elseif")k=bL(k,bJ(x.Condition))k=bL(k,"then")else k=bL(k,"else")end;k=bL(k,bI(x.Body))end;k=bL(k,"end")elseif bU.AstType=='WhileStatement'then k=bL("while",bJ(bU.Condition))k=bL(k,"do")k=bL(k,bI(bU.Body))k=bL(k,"end")elseif bU.AstType=='DoStatement'then k=bL(k,"do")k=bL(k,bI(bU.Body))k=bL(k,"end")elseif bU.AstType=='ReturnStatement'then k="return"for H=1,#bU.Arguments do k=bL(k,bJ(bU.Arguments[H]))if H~=#bU.Arguments then k=k..","end end elseif bU.AstType=='BreakStatement'then k="break"elseif bU.AstType=='RepeatStatement'then k="repeat"k=bL(k,bI(bU.Body))k=bL(k,"until")k=bL(k,bJ(bU.Condition))elseif bU.AstType=='Function'then bU.Scope:RenameVars()if bU.IsLocal then k="local"end;k=bL(k,"function ")if bU.IsLocal then k=k..bU.Name.Name else k=k..bJ(bU.Name)end;k=k.."("if#bU.Arguments>0 then for H=1,#bU.Arguments do k=k..bU.Arguments[H].Name;if H~=#bU.Arguments then k=k..","elseif bU.VarArg then print("Apply vararg")k=k..",..."end end elseif bU.VarArg then k=k.."..."end;k=k..")"k=bL(k,bI(bU.Body))k=bL(k,"end")elseif bU.AstType=='GenericForStatement'then bU.Scope:RenameVars()k="for "for H=1,#bU.VariableList do k=k..bU.VariableList[H].Name;if H~=#bU.VariableList then k=k..","end end;k=k.." in"for H=1,#bU.Generators do k=bL(k,bJ(bU.Generators[H]))if H~=#bU.Generators then k=bL(k,',')end end;k=bL(k,"do")k=bL(k,bI(bU.Body))k=bL(k,"end")elseif bU.AstType=='NumericForStatement'then k="for "k=k..bU.Variable.Name.."="k=k..bJ(bU.Start)..","..bJ(bU.End)if bU.Step then k=k..","..bJ(bU.Step)end;k=bL(k,"do")k=bL(k,bI(bU.Body))k=bL(k,"end")end;bK=bK+#k;return k end;bI=function(bV)local k=''bV.Scope:RenameVars()for c,a_ in pairs(bV.Body)do k=bL(k,bT(a_),';')end;return k end;bH.Scope:RenameVars()return bI(bH)end;LuaMinify=function(v)local x,bH=a7(v)if not x then return false,bH end;return true,bG(bH)end


LuaCCDecode = function(Code)
		assert(Code,"Code must be non nil")
		assert(type(Code)=="string","Code must be a string")
		Classes = {
			bool = function(x)
				return x ~= nil and x ~= false
			end;
			int = function(x)
				return math.floor((tonumber(x) or 0) + 0.5)
			end;
			string = tostring;
			number = function(x)
				return tonumber(x) or 0
			end;
		};
		Types = {
			["string"] = true;
			["boolean"] = true;
			["number"] = true;
			["thread"] = true;
			["table"] = true;
			["function"] = true;
			["userdata"] = true;
		};
		Combine = {
			-- Lua
			"%d+%.%d+";
			-- Compiler
			"=="; "!="; ">="; "<="; "%+="; "%-="; "%*="; "%/="; "%.=";"%%=";"%^=";"%+%+"; "%-%-";
			-- Pre compiler
			"[_%w]+"; "%p";
		};
		Replace = {
			["!="] = "~=";
			["!"] = "not";
			["|"] = "or";
			["&"] = "and";
		};
		Ignore = {
			{Start = "'", End = "'", Compile = true};--String
			{Start = "\"", End = "\"", Compile = true};--Long string
			{Start = "/*", End = "*/", Compile = false};--Long comment
			{Start = "//", End = string.char(10), Compile = false};--Short comment
		};
		CaseSensitive = true
		Minify = false
		IncrementaryOperators = true
		AssignmentOperators = true
		TypeClasses = true
		StrictClasses = true
		Conditional = true
		UsingNamespace = true
		TypeOperators = true
		BuiltIn = [[]]
		
		BuiltInUsing = [[
		function using(namespace)
			for i,v in next,_ENV[namespace] do
				_ENV[i]=v
			end
		end
		]]
		BuiltInClasses = [[
		Classes = {
			bool = function(x)
				return x ~= nil and x ~= false
			end;
			int = function(x)
				return math.floor((tonumber(x) or 0) + 0.5)
			end;
			string = tostring;
			number = function(x)
				return tonumber(x) or 0
			end;
		};
		]]
		BuiltInOperators = [[
		local function argCheck(var, t, argNum, funcName)
		   assert(type(var) == t, "bad argument #"..argNum.." to "..funcName.." ("..t.." expected, got "..type(var)..")");
		end


		--Strings
		
		debug.setmetatable("", { __add, __sub, __mul,__div,__unm,__call,__mod,__pairs,__ipairs,__index,__metatable = nil })


		-- Concatenation: s1 + s2 = s1..s2
		debug.getmetatable("").__add = function (s1, s2)
		   argCheck(s1, "string", 1, "string addition");
		   argCheck(s2, "string", 2, "string addition");
		   return tostring(s1)..tostring(s2);
		end

		-- Gsub: s1 - s2 = s1:gsub(s2, "");
		debug.getmetatable("").__sub = function (s1, s2)
		   argCheck(s1, "string", 1, "string subtraction");
		   argCheck(s2, "string", 2, "string subtraction");
		   return string.gsub(tostring(s1), tostring(s2), "");
		end

		-- Repititon: "x" * y = ("x"):rep(y);
		-- If y is negative then reverses string
		-- "Hello" * -2 = "olleHolleH"
		debug.getmetatable("").__mul = function (s, t)
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
		debug.getmetatable("").__div = function (str, split)
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
		debug.getmetatable("").__unm = function (str)
		   argCheck(str, "string", 1, "string negation");
		   return tostring(str) * -1;
		end

		-- String slicing (like Python):
		-- stringVariable("start:finish:increment")
		-- or stringVariable{"start:finish:increment"}
		-- Or normal string.sub calling without increment
		debug.getmetatable("").__call = function (str, ...)
		   argCheck(str, "string", 1, "string slicing call");
		   str = tostring(str);
		   local slices = {...};
		   if type(table.unpack(slices)) == "table" then slices = table.unpack(slices) end
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
		debug.getmetatable("").__mod = function (str, tbl)
		   argCheck(str, "string", 1, "string interpolation");
		   argCheck(tbl, "table", 2, "string interpolation");
		   return tostring(str):gsub("%%([%w_]+)", function (v)
			  if (tbl[v]) then
				 return tbl[v];
			  end
		   end);
		end

		-- for i,v in pairs "Hello" do print(v)
		--H e l l o
		debug.getmetatable("").__pairs = function(str)
		   argCheck(str, "string", 1, "string pairs");
		   local i,n = 0,#s
		   return function()
			  i = i + 1
			  if i <= n then
				 return i,s:sub(i,i)
			  end
		   end
		end

		-- for i,v in ipairs "Hello" do print(v)
		--H e l l o
		debug.getmetatable("").__ipairs = function(str)
		   argCheck(str, "string", 1, "string ipairs");
		   local i,n = 0,#s
		   return function()
			  i = i + 1
			  if i <= n then
				 return i,s:sub(i,i)
			  end
		   end
		end

		-- a = "Hello" 
		--print a[1] -- H
		--debug.getmetatable("").__index = function(str,i)
		--   argCheck(str, "number", 1, "string indexing")
		--   return string.sub(str,i,i) 
		--end

		--Preventing the change of Lua Types
		debug.getmetatable("").__metatable = function() 
		  return nil 
		end 

		--Booleans

		debug.setmetatable(true,{__unm,__tostring,__metatable = nil })

		--  -true == false  -false == true
		debug.getmetatable(true).__unm = function(bool)
		   argCheck(bool, "boolean", 1, "boolean negation");
		   return (not bool)
		end

		--tostring(false) == "false"
		debug.getmetatable(true).__tostring = function(bool) 
		   argCheck(bool, "boolean", 1, "boolean tostring");
		   return(bool == true and "true" or "false")  
		end

		--Preventing the change of Lua Types
		debug.getmetatable(true).__metatable = function()
			return nil 
		end

		--Functions

		debug.setmetatable(function() end, {__metatable = nil})

		--Preventing the change of Lua Types
		debug.getmetatable(function() end).__metatable = function()
			return nil 
		end

		--Nil

		debug.setmetatable(nil, {__metatable = nil})

		--Preventing the change of Lua Types
		debug.getmetatable(nil).__metatable = function()
			return nil 
		end

		--Threads

		debug.setmetatable(coroutine.create(function() end), {__metatable = nil})

		--Preventing the change of Lua Types
		debug.getmetatable(coroutine.create(function() end)).__metatable = function()
			return nil 
		end
]]
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
			local isConditional = false
			local explicitPar = {}
			local Parameters = {}
			local Brackets = {}

			-- Compile
			for i, l in pairs(preCompiled) do
				Compiled = Compiled .. " "
				if not l then

				-- Function
				elseif l == "function" then
					isFunc = true
					Compiled = Compiled .. l

				-- If
				elseif l == "if" then
					isThen = true
					Compiled = Compiled .. l

				-- For and while
				elseif l == "for" or l == "while" then
					isDo = true
					Compiled = Compiled .. l

				-- Scope and table creation
				elseif l == "{" then
					if isFunc then
						isFunc = false
						Brackets[#Brackets + 1] = "scope"
						for parName, parType in pairs(explicitPar) do
							Compiled = Compiled .. "assert(type(" .. parName .. ") == \"" .. parType .. "\", \"Invalid argument '\" .. type(" .. parName .. ") .. \"' (" .. parType .. " expected)\")"
						end
						for parName, parVal in pairs(Parameters) do
							Compiled = Compiled .. parName .. " = " .. parName .. " or " .. parVal
						end
						Parameters = {}
					elseif isThen then
						isThen = false
						Compiled = Compiled .. "then"
						Brackets[#Brackets + 1] = "scope"
					elseif isDo then
						isDo = false
						Compiled = Compiled .. "do"
						Brackets[#Brackets + 1] = "scope"
					else
						Compiled = Compiled .. "({"
						Brackets[#Brackets + 1] = "table"
					end

				-- Scope and table ending
				elseif l == "}" then
					if Brackets[#Brackets] == "scope" then
						Compiled = Compiled .. "end"
					else
						Compiled = Compiled .. "})"
					end
					Brackets[#Brackets] = nil

				-- Augmented assignment operators
				elseif AssignmentOperators and(l == "+=" or l == "-=" or l == "*=" or l == "/=" or l == ".=" or l == "%=" or l == "^=") then
					for j = 1, Compiled:len() do
						if loadstring("x=(" .. Compiled:sub(j) .. ")") then
							local Operator = l == ".=" and ".." or l:sub(1, 1)
							Compiled = Compiled:sub(1, j - 1) .. Compiled:sub(j) .. " = " .. Compiled:sub(j) .. " " .. Operator
							break
						end
					end
					
				elseif l == "?" and Conditional then
					isConditional = true
					l = "and"
					Compiled = Compiled..l
						

				-- Unary operators
				elseif IncrementaryOperators and (l == "++" or l == "--") then
					for j = 1, Compiled:len() do
						if loadstring("x=(" .. Compiled:sub(j) .. ")") then
							Compiled = Compiled:sub(1, j - 1) .. Compiled:sub(j) .. " = " .. Compiled:sub(j) .. " " .. l:sub(1, 1) .. " 1"
							break
						end
					end

				-- Specific classes
				elseif l == ":" then
					if Conditional and isConditional then
						isConditional = false
						l = "or"
						Compiled = Compiled..l
					elseif TypeClasses then	
						for j = 1, Compiled:len() do
							if loadstring("x=(" .. Compiled:sub(j) .. ")") then
								Compiled = Compiled:sub(1, j - 1) .. "Classes." .. preCompiled[i + 1] .. "(" .. Compiled:sub(j) .. ")"
								preCompiled[i + 1] = nil
								break
							end
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
				elseif Types[l] and isFunc and StrictClasses then
					explicitPar[preCompiled[i + 1]] = l

				-- Everything else
				else
					Compiled = Compiled .. l
				end
			end

			-- Run script
			if UsingNamespace then Compiled = BuiltInUsing..Compiled end
			if TypeClasses then Compiled = BuiltInClasses..Compiled end
			if TypeOperators then Compiled = BuiltInOperators..Compiled end
			Compiled = BuiltIn..Compiled
			if not CaseSensitive then Compiled = Compiled:lower() end
			if Minify then _,Compiled = LuaMinify(Compiled) end
			local Func, Error = loadstring(Compiled)
			if Func then
				return Compiled
			else
				return "--[[Your code failed!]]"..Compiled
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
		filename = name or "Compiled "..file
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
		Code = x:read("*all")
		x:close()
		loadstring(LuaCCDecode(Code))()
	end;
											
	Run = function(Code)
		loadstring(LuaCCDecode(Code))()
	end;
	Decode = function(Code)
		return LuaCCDecode(Code)
	end;
}
mt = {__metatable = true}
setmetatable(LuaCC,mt)

return LuaCC
