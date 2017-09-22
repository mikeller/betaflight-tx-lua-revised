local a=68;local b=250;local c=80;local d=2;local e=3;local f=4;local g=5;local h=d;local i=1;local j=1;local k=0;local l=0;local m=0;local n=0;local o=false;backgroundFill=backgroundFill or ERASE;foregroundColor=foregroundColor or SOLID;globalTextOptions=globalTextOptions or 0;local function p(q)local r=SetupPages[i]if r.values then if r.preSave then r.preSave(r)end;protocol.mspWrite(r.write,r.values)k=getTime()if h==f then m=m+1 else h=f;m=0;n=protocol.saveMaxRetries or 2;l=protocol.saveTimeout or 150 end end end;local function s()SetupPages={}h=d;k=0 end;local function t()protocol.mspRead(a)s()end;local function u()protocol.mspRead(b)end;local v={{t="save page",f=p},{t="reload",f=s},{t="reboot",f=t}}local w=false;local x=false;local function y(z,A)if z==nil or A==nil then return end;local r=SetupPages[i]if z==r.write then if r.eepromWrite then u()end;o=false;return end;if z==b then if r.reboot then t()end;s()h=d;k=0;return end;if z~=r.read then return end;if#A>0 then r.values={}for B=1,#A do r.values[B]=A[B]end;if r.postLoad then r.postLoad(r)end end end;local function C()return#SetupPages[i].fields end;local function D(E)i=i+E;if i>#PageFiles then i=1 elseif i<1 then i=#PageFiles end;j=1 end;local function F(E)j=j+E;if j>C()then j=1 elseif j<1 then j=C()end end;local function G(E)x=x+E;if x>#v then x=1 elseif x<1 then x=#v end end;local function H(r)if r.read and(r.reqTS==nil or r.reqTS+c<=getTime())then r.reqTS=getTime()protocol.mspRead(r.read)end end;function drawScreenTitle(I)lcd.drawFilledRectangle(0,0,LCD_W,10)lcd.drawText(1,1,I,INVERS)end;local function J(r,K)local I=r.title;drawScreenTitle("Betaflight / "..I)for B=1,#r.text do local L=r.text[B]if L.to==nil then lcd.drawText(L.x,L.y,L.t,globalTextOptions)else lcd.drawText(L.x,L.y,L.t,L.to)end end;local M="---"for B=1,#r.fields do local L=r.fields[B]local N=globalTextOptions;if B==j then N=INVERS;if h==e then N=N+BLINK end end;local O=20;if L.t~=nil then lcd.drawText(L.x,L.y,L.t..":",globalTextOptions)if L.sp~=nil then O=L.sp end else O=0 end;if r.values then if(#r.values or 0)>=r.minBytes then if not L.value and L.vals then for P=1,#L.vals do L.value=bit32.bor(L.value or 0,bit32.lshift(r.values[L.vals[P]],(P-1)*8))end;L.value=L.value/(L.scale or 1)end end end;M="---"if L.value then if L.upd and r.values then L.upd(r)end;M=L.value;if L.table and L.table[L.value]then M=L.table[L.value]end end;lcd.drawText(L.x+O,L.y,M,N)end end;local function Q(M,R,S)if M<R then M=R elseif M>S then M=S end;return M end;local function T()local r=SetupPages[i]return r.fields[j]end;local function U(E)local r=SetupPages[i]local L=r.fields[j]local P=L.i or j;local V=L.scale or 1;L.value=Q(L.value+E*(L.mult or 1)/V,L.min/V or 0,L.max/V or 255)for P=1,#L.vals do r.values[L.vals[P]]=bit32.rshift(L.value*V,(P-1)*8)end;if L.upd and r.values then L.upd(r)end end;local function W()local X=MenuBox.x;local Y=MenuBox.y;local Z=MenuBox.w;local _=MenuBox.h_line;local a0=MenuBox.h_offset;local a1=#v*_+a0*2;lcd.drawFilledRectangle(X,Y,Z,a1,backgroundFill)lcd.drawRectangle(X,Y,Z-1,a1-1,foregroundColor)lcd.drawText(X+_/2,Y+a0,"Menu:",globalTextOptions)for B,a2 in ipairs(v)do local N=globalTextOptions;if x==B then N=N+INVERS end;lcd.drawText(X+MenuBox.x_offset,Y+(B-1)*_+a0,a2.t,N)end end;local a3=0;local a4=0;function run_ui(a5)local a6=getTime()if a3+50<a6 then s()end;a3=a6;if h==f then if k+l<a6 then if m<n then p()else h=d;s()end end end;mspProcessTxQ()if a5==EVT_MENU_LONG then x=1;h=g elseif EVT_PAGEUP_FIRST and a5==EVT_ENTER_LONG then x=1;a4=1;h=g elseif h==g then if a5==EVT_EXIT_BREAK then h=d elseif a5==EVT_PLUS_BREAK or a5==EVT_ROT_LEFT then G(-1)elseif a5==EVT_MINUS_BREAK or a5==EVT_ROT_RIGHT then G(1)elseif a5==EVT_ENTER_BREAK then if a4==1 then a4=0 else h=d;v[x].f()end end elseif h<=d then if a5==EVT_PAGEUP_FIRST then SetupPages[i]=nil;D(-1)elseif a5==EVT_MENU_BREAK or a5==EVT_PAGEDN_FIRST then SetupPages[i]=nil;D(1)elseif a5==EVT_PLUS_BREAK or a5==EVT_ROT_LEFT then F(-1)elseif a5==EVT_MINUS_BREAK or a5==EVT_ROT_RIGHT then F(1)elseif a5==EVT_ENTER_BREAK then local r=SetupPages[i]local a7=r.fields[j]local P=a7.i or j;if r.values and r.values[P]and a7.ro~=true then h=e end elseif a5==EVT_EXIT_BREAK then return protocol.exitFunc()end elseif h==e then if a5==EVT_EXIT_BREAK or a5==EVT_ENTER_BREAK then h=d elseif a5==EVT_PLUS_FIRST or a5==EVT_PLUS_REPT or a5==EVT_ROT_RIGHT then U(1)elseif a5==EVT_MINUS_FIRST or a5==EVT_MINUS_REPT or a5==EVT_ROT_LEFT then U(-1)end end;if SetupPages[i]==nil then SetupPages[i]=assert(loadScript(radio.templateHome..PageFiles[i]))()end;local K=false;local r=SetupPages[i]if not r.values and h==d then H(r)K=true end;lcd.clear()if TEXT_BGCOLOR then lcd.drawFilledRectangle(0,0,LCD_W,LCD_H,TEXT_BGCOLOR)end;J(r,K)if protocol.rssi()==0 then lcd.drawText(NoTelem[1],NoTelem[2],NoTelem[3],NoTelem[4])end;if h==g then W()elseif h==f then lcd.drawFilledRectangle(SaveBox.x,SaveBox.y,SaveBox.w,SaveBox.h,backgroundFill)lcd.drawRectangle(SaveBox.x,SaveBox.y,SaveBox.w,SaveBox.h,SOLID)lcd.drawText(SaveBox.x+SaveBox.x_offset,SaveBox.y+SaveBox.h_offset,"Saving...",DBLSIZE+BLINK+globalTextOptions)end;y(mspPollReply())return 0 end;return run_ui
