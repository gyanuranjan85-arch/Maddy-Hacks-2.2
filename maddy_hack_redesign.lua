gg.setVisible(false) 
gg.alert("M A D D Y\nControl Panel\n\nFree script   ·   Discord: under development\n\nTap the GG icon at any time to reopen the menu.", "Start")

--------------------------------------------------------------------
--  M A D D Y   ·   Control Panel
--  Free script   ·   Discord: under development
--------------------------------------------------------------------

menuuuvis = 1
gg.clearResults()
gg.clearList()

-- ==========================================
-- GLOBAL ERROR & TOAST FIX
-- ==========================================

-- Fix missing showError function called at line 170
function showError(msg)
    gg.toast("MADDY  ·  Error  ·  " .. tostring(msg or "Failed execution"))
end

-- Fix toast object compatibility
toast = {
    success = function(msg) gg.toast(msg) end,
    hint = function(msg) gg.toast(msg) end,
    error = function(msg) gg.toast(msg) end
}


--------------------------------------------------------------------
--  MADDY UI KIT  -  presentation layer only (no feature logic)
--      ●  switch is on         ○  switch is off
--      ►  runs an action or opens a menu         ◄  goes back
--------------------------------------------------------------------
MUI = {}

-- a switch is on when it holds the script's "on" token or a true boolean
function MUI.isOn(s) return s == "⊂❍ " or s == true end

-- row builders
function MUI.sw(name, s) return (MUI.isOn(s) and "●" or "○") .. "   " .. name end
function MUI.go(name) return "►   " .. name end
function MUI.back() return "◄   Back" end
function MUI.item(i, name) return string.format("%02d   %s", i, name) end

-- counters
function MUI.count(...)
    local n = 0
    for i = 1, select("#", ...) do
        if MUI.isOn((select(i, ...))) then n = n + 1 end
    end
    return n
end
function MUI.num(n, one, many) return n .. " " .. (n == 1 and one or many) end
function MUI.badge(n) return n > 0 and ("   ·   " .. n .. " on") or "" end

-- dialog header: wordmark + breadcrumb, then a status line
--   sub = number -> "N active" + legend      sub = string -> shown as is
function MUI.head(path, sub)
    local t = "M A D D Y   ›   " .. path
    if type(sub) == "number" then
        t = t .. "\n" .. (sub > 0 and (sub .. " active") or "All off") .. "   ·   ● on    ○ off"
    elseif sub then
        t = t .. "\n" .. sub
    end
    return t
end


--╔════════════════════════╗
--║    SPECIAL EFFECTS     ║
--╚════════════════════════╝

function showSuccess() 
    gg.toast("MADDY  ·  Done") 
end

--╔══════════════════╗
--║GLOBAL VARIABLES & SETUP                       
--╚═════════════════╝

fg = {}
Write = {}
fg.clean = gg.clearResults
Z = {}
ts = gg.toast
alert = gg.alert

-- Memory Flags Configuration
A = 32        -- ARM
As = 524288   -- Anonymous
B = 131072    -- BSS
Xa = 16384    -- Executable
Xs = 32768    -- Executable
Ca = 4        -- C++ Data (a)
Cb = 16       -- C++ Data (b)
Cd = 8        -- C++ Data (d)
Ch = 1        -- C++ Heap
J = 65536     -- Java
Jh = 2        -- Java Heap
O = -2080896  -- Other
Ps = 262144   -- Primary Stack
S = 64        -- Stack
V = 1048576   -- View
F = 16        -- Float Type
D = 4         -- Dword Type
E = 64        -- Qword Type
Q = 32        -- Qword Type
W = 2         -- Word Type
X = 8         -- XOR
Byte = 1      -- Byte Type

--╔════════════════════════╗
--║        CORE FUNCTIONS   ║
--╚════════════════════════╝

function setvalue(add, value, flags, dj)
    local WY = {}
    WY[1] = {}
    WY[1].address = add
    WY[1].value = value
    WY[1].flags = flags
    if dj == true then
        WY[1].freeze = true
        gg.addListItems(WY)
    else
        gg.setValues(WY)
    end
end

function Z.S(num, ty, nc, mb, qs, zd)
    gg.clearResults()
    gg.setRanges(nc)
    gg.searchNumber(num, ty, false, gg.SIGN_EQUAL, qs or 1, zd or -1)
    if mb ~= nil and mb ~= false and mb then
        gg.refineAddress(mb)
    end
    Result = gg.getResults(gg.getResultCount())
end

function Z.C(num, C, ty)
    if (Result and #Result ~= 0) then
        t = {}
        for i, v in ipairs(Result) do
            t[i] = {}
            t[i].address = v.address + C
            t[i].flags = ty
        end
        t = gg.getValues(t)
        for i, v in ipairs(t) do
            if v.value ~= num then
                Result[i] = nil
            end
        end
        local Z2 = {}
        for i, v in pairs(Result) do
            Z2[#Z2 + 1] = v
        end
        Result = Z2
    end
end

function Z.bc()
    data = {}
    if Result == nil or #Result == 0 then
        gg.toast("MADDY  ·  No values found")
    else
        for i, v in pairs(Result) do
            data[#data + 1] = v.address
        end
        gg.loadResults(Result)
    end
    Result = nil
end
function Z.W(nn, off, ty, dj)
    if (Result) then Z.bc() end
    if #data > 0 then
        for i, v in ipairs(data) do
            local val = nn
            if val == "" then
                local t = {{address = v + off, flags = ty}}
                t = gg.getValues(t)
                val = t[1].value
            end
            setvalue(v + off, val, ty, dj or false)
        end
    end
end

function Z.A(varName, offset, baseAddr)
    if not baseAddr then
        local results = gg.getResults(9999)
        if #results == 0 then
            gg.clearResults()
            showError()
            return
        end
        baseAddr = results[1].address
    end
    
    local targetAddr = baseAddr + (offset or 0)
    
    if varName and type(varName) == "string" then
        _G[varName] = targetAddr
    end
    
    return targetAddr
end

function hookPLAYER(q1w, w2e, e3r, r4t)
    Z.S("100.14399719238", F, Ca|O)
    if not Result or #Result == 0 then
        showError()
        return false
    end
    
    local off = tonumber(q1w) or 0
    for i, v in ipairs(Result) do
        setvalue(v.address + off, e3r, w2e, r4t or false)
    end
    
    gg.clearResults()
    return true
end

function doTeleport(x, y, z)
    gg.clearResults()
    gg.setRanges(Ca | O)
    gg.searchNumber("4575657250219098112", Q, false, gg.SIGN_EQUAL, 1, -1)
    
    local results = gg.getResults(1)
    if results and #results > 0 then
        local baseAddr = results[1].address
        
        -- Safely set X, Y, Z coordinates with validation
        if x ~= nil then setvalue(baseAddr + 132, x, F, false) end
        if y ~= nil then setvalue(baseAddr + 136, y, F, false) end
        if z ~= nil then setvalue(baseAddr + 140, z, F, false) end
        
        showSuccess()
    else
        showError()
    end
    gg.clearResults()
end

--╔══════════════════════╗
--║    MADDY AIMBOT SYSTEM        ║
--╚══════════════════════╝
-- Helper function to format toggle status (ON/OFF)
function TOG(state)
    if state then
        return " [ON]"
    else
        return " [OFF]"
    end
end

-- Table defining the new aim options (Name 'n', Value 'v', State 's')
aim_st = {
    {n = "Ultra Legit", v = "1051999999", s = false},
    {n = "Legit",       v = "1055999999", s = false},
    {n = "Medium",      v = "1076999999", s = false},
    {n = "Ultra",       v = "1080999999", s = false},
    {n = "HvH",         v = "1089999999", s = false}
}

function aimnew()
    local inNewAim = true
    while inNewAim do
        gg.setVisible(false)
        local names = {}
        local act = 0
        for i, v in ipairs(aim_st) do 
            table.insert(names, MUI.sw(v.n, v.s)) 
            if v.s then act = act + 1 end
        end
        table.insert(names, MUI.back())
        
        local r = gg.choice(names, nil, MUI.head("AIMBOT   ›   NEW MODELS", act))
        if r and r <= #aim_st then
            aim_st[r].s = not aim_st[r].s
            local old = "1042536202"
            
            gg.clearResults()
            if aim_st[r].s then
                gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER)
                gg.searchNumber(old, gg.TYPE_DWORD)
                if gg.getResultCount() > 0 then
                    local res = gg.getResults(10000)
                    gg.editAll(aim_st[r].v, gg.TYPE_DWORD)
                    gg.toast("MADDY  ·  Activated")
                else
                    gg.toast("MADDY  ·  Value not found")
                end
            else
                gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER)
                gg.searchNumber(aim_st[r].v, gg.TYPE_DWORD)
                if gg.getResultCount() > 0 then
                    local res = gg.getResults(10000)
                    gg.editAll(old, gg.TYPE_DWORD)
                    gg.toast("MADDY  ·  Deactivated")
                else
                    gg.toast("MADDY  ·  Value not found")
                end
            end
            gg.clearResults()
        elseif r == #aim_st + 1 then 
            break
        elseif r == nil then 
            inNewAim = false 
        end
    end
end

function aimold()
    local aims = {
        {"Ultra Legit", "1051999999", "1042536202"}, 
        {"Legit",       "1055999999", "1042536202"}, 
        {"Medium",      "1076999999", "1042536202"}, 
        {"Ultra",       "1080999999", "1042536202"}, 
        {"HvH",         "1089999999", "1042536202"}
    }
    local names = {}
    for i, v in ipairs(aims) do 
        table.insert(names, MUI.go(v[1])) 
    end
    table.insert(names, MUI.back())
    
    local s = gg.choice(names, nil, MUI.head("AIMBOT   ›   OLD MODELS", "Pick a model   ·   tap the GG icon to stop"))
    if s and s <= #aims then
        gg.setVisible(false)
        gg.toast("MADDY  ·  Running  ·  tap the GG icon to stop")
        for i = 1, 10000 do
            if gg.isVisible() then break end
            gg.clearResults()
            gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER)
            gg.searchNumber(aims[s][3], gg.TYPE_DWORD)
            if gg.getResultCount() > 0 then
                gg.getResults(10000)
                gg.editAll(aims[s][2], gg.TYPE_DWORD)
            end
            gg.clearResults()
            
            for j = 1, 20 do
                if gg.isVisible() then
                    gg.setVisible(false)
                    gg.clearResults()
                    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_C_DATA | gg.REGION_OTHER)
                    gg.searchNumber(aims[s][2], gg.TYPE_DWORD)
                    if gg.getResultCount() > 0 then
                        gg.getResults(10000)
                        gg.editAll(aims[s][3], gg.TYPE_DWORD)
                    end
                    gg.clearResults()
                    gg.toast("MADDY  ·  Stopped  ·  back to menu")
                    return aimold()
                end
                gg.sleep(200)
            end 
        end
        gg.setVisible(true)
        gg.clearResults()
    elseif s == #aims + 1 then 
        return
    end
end

function MaddyAimMenu()
    local inAimMenu = true
    while inAimMenu do
        gg.setVisible(false)
        local aChoice = gg.choice({
            MUI.go("Old Aim Models"),
            MUI.go("New Aim Models"),
            MUI.back()
        }, nil, MUI.head("AIMBOT", MUI.n_aim()))
        
        if aChoice == 1 then 
            aimold()
        elseif aChoice == 2 then 
            aimnew()
        elseif aChoice == 3 then 
            break
        elseif aChoice == nil then 
            inAimMenu = false 
        end
    end
end
MADDYAimMenu = MaddyAimMenu   -- alias: both spellings of the name now work

--╔═════════════════════╗
--║       PLAYER MODS          ║
--╚═════════════════════╝
local shv222 = "❍⊃ "
local mbq = "❍⊃ "
local gm4 = "❍⊃ "
local gm9 = "❍⊃ "
local gm5 = "❍⊃ "
local suic = "❍⊃ "
local walg = "❍⊃ "
local fastkil = "❍⊃ "
local hjj = "❍⊃ "
local ghh = "❍⊃ "
local whh = "❍⊃ "
local graviq = "❍⊃ "
local graviqq = "❍⊃ "

function player()
menuuuvis = 0
local MADDY_2 = gg.choice ({
 MUI.sw("Speed Hack", shv222),
 MUI.sw("Speed Hack V2", mbq),
 MUI.sw("Godmode", gm4),
 MUI.sw("Godmode V2", gm9),
 MUI.sw("Armor Nullifier", gm5),
 MUI.go("Restore Health"),
 MUI.go("Suicide"),
 MUI.sw("Walk Through Walls", walg),
 MUI.go("Flip Up"),
 MUI.go("Flip Down"),
 MUI.sw("Fast Fist Kill", fastkil),
 MUI.sw("High Jump", hjj),
 MUI.sw("Sharp Turns", whh),
 MUI.sw("Gravity", graviq),
 MUI.sw("Gravity V2", graviqq)
},nil,MUI.head("PLAYER", MUI.n_player()))

if not MADDY_2 then mainMenu() end
if MADDY_2 == 1 then shv22() end 
if MADDY_2 == 2 then fovqqq() end 
if MADDY_2 == 3 then gm2() end 
if MADDY_2 == 4 then gm8() end 
if MADDY_2 == 5 then gm3() end 
if MADDY_2 == 6 then hpq() end 
if MADDY_2 == 7 then suicc() end 
if MADDY_2 == 8 then walgh() end 
if MADDY_2 == 9 then flpp() end 
if MADDY_2 == 10 then flpp1() end 
if MADDY_2 == 11 then fastk() end 
if MADDY_2 == 12 then hj() end 
if MADDY_2 == 13 then wh() end 
if MADDY_2 == 14 then gravity() end 
if MADDY_2 == 15 then gravityv2() end 
menuuuvis = -1
end
function gm2()local _m=(gm4=="❍⊃ ")if hookPLAYER(-4,F,_m and 505050 or 100)then gm4=_m and"⊂❍ "or"❍⊃ "if _m then abc()else cba()end end gg.clearResults()player()end
function hj()local s=hjj=="❍⊃ ";hjj=s and"⊂❍ "or"❍⊃ ";Z.S("4798022456217645875",Q,Cd|O);Z.W(s and"-150"or"-0.10000000149",-0x4,F);gg.clearResults();if s then abc()else cba()end;player()end
function fovqqq()local _m=(mbq=="❍⊃ ")Z.S(_m and"4489188110487257088"or"4489188110498131456",Q,Ca|Cd|O)if #Result~=0 then gg.editAll(_m and"4489188110498131456"or"4489188110487257088",Q)mbq=_m and"⊂❍ "or"❍⊃ "if _m then abc()else cba()end else qwea()end gg.clearResults()player()end
function walgh()local _w=(walg=="❍⊃ ")Z.S(_w and"1114636288"or"1114767360",Q,Ca|O|Cd)if #Result~=0 then gg.editAll(_w and"1114767360"or"1114636288",Q)walg=_w and"⊂❍ "or"❍⊃ "if _w then abc()else cba()end else qwea()end gg.clearResults()player()end
function fastk()local _f=(fastkil=="❍⊃ ")Z.S(_f and"9187343240761165228"or"4489188110505082880",Q,Ca|O|Cd)if #Result~=0 then gg.editAll(_f and"4489188110505082880"or"9187343240761165228",Q)Z.S(_f and"4489188110487257088"or"4489188110499840000",Q,Ca|O|Cd)if #Result~=0 then gg.editAll(_f and"4489188110499840000"or"4489188110487257088",Q)end fastkil=_f and"⊂❍ "or"❍⊃ "if _f then abc()else cba()end else qwea()end gg.clearResults()player()end
function gravityv2()local s=graviqq=="❍⊃ ";graviqq=s and"⊂❍ "or"❍⊃ ";Z.S("-4 651 317 692 702 523 392",Q,Cd|O|Cd);Z.W(s and"-1164859368"or"-1140649361",-0x4,D);gg.clearResults();if s then abc()else cba()end;player()end
function gravity()local s=graviq=="❍⊃ ";graviq=s and"⊂❍ "or"❍⊃ ";Z.S("-4 651 317 692 702 523 392",Q,Cd|O|Cd);Z.W(s and"-1164854368"or"-1140649361",-0x4,D);gg.clearResults();if s then abc()else cba()end;player()end
function shv22()local s=shv222=="❍⊃ ";shv222=s and"⊂❍ "or"❍⊃ ";Z.S("4647714816510698455",Q,Cd|O|Ca);Z.W(s and"4489188112626352128"or"4489188110482223923",0x18,Q);gg.clearResults();if s then abc()else cba()end;player()end
function flpp1()Z.S("4575657250219098112",Q,Ca|O);if #Result~=0 then local t={};for i,v in ipairs(Result)do t[i]={address=v.address+140,flags=F}end;t=gg.getValues(t);for i,v in ipairs(t)do v.value=v.value-7 end;gg.setValues(t);abc()else qwea()end;gg.clearResults();player()end
function flpp()Z.S("4575657250219098112",Q,Ca|O);if #Result~=0 then local t={};for i,v in ipairs(Result)do t[i]={address=v.address+140,flags=F}end;t=gg.getValues(t);for i,v in ipairs(t)do v.value=v.value+7 end;gg.setValues(t);abc()else qwea()end;gg.clearResults();player()end
function gm3()if gm5=="❍⊃ "then if hookPLAYER(4,F,"9990",true)then gm5="⊂❍ "abc()end else gm5="❍⊃ "gg.clearList()cba()end gg.clearResults()player()end
function gm8()local _m=(gm9=="❍⊃ ")if not _m then gg.clearList()end if hookPLAYER(-4,F,_m and"9999989.0"or"100",_m)then gm9=_m and"⊂❍ "or"❍⊃ "if _m then abc()else cba()end end player()end
function hpq()if hookPLAYER(-4,F,100)then abc()end player()end
function suicc()if hookPLAYER(-4,F,0)then abc()end player()end
function wh()local _w=(whh=="❍⊃ ")if not _w then gg.clearList()end if hookPLAYER(28,F,_w and"65"or"7.5",_w)then whh=_w and"⊂❍ "or"❍⊃ "if _w then abc()else cba()end end player()end

--╔════════════════════╗
--║         CAR MODS          ║
--╚════════════════════╝
local gmcarchik = "❍⊃ "
local shcar = "❍⊃ "
local mopsh = "❍⊃ "
local nitr = "❍⊃ "
local gidraa = "❍⊃ "
local upmotor = "❍⊃ "
local perevorot1 = "❍⊃ "
local carkoles1 = "❍⊃ "
function car()
menuuuvis = 0
  local mashinka = gg.choice ({
   MUI.sw("Godmode", gmcarchik),
   MUI.go("Restore Health"),
   MUI.go("Break Car"),
   MUI.sw("Give Nitro", nitr),
   MUI.sw("Give Hydraulics", gidraa),
   MUI.sw("Speed Hack", shcar),
   MUI.sw("Accelerate Scooter", mopsh),
   MUI.go("Launch Into Space"),
   MUI.go("Throw Up"),
   MUI.sw("Engine Upgrade", upmotor),
   MUI.sw("Anti-Rollover", perevorot1),
   MUI.sw("Put On Wheels", carkoles1)},nil,MUI.head("VEHICLE", MUI.n_car()))
  
  if not mashinka then mainMenu() end
  if mashinka == 1 then gmcarq() end 
  if mashinka == 2 then hpcarq() end 
  if mashinka == 3 then breakcar() end 
  if mashinka == 4 then nitrolol() end 
  if mashinka == 5 then gidra() end 
  if mashinka == 6 then shcars() end 
  if mashinka == 7 then mopedsh() end
  if mashinka == 8 then kosmos() end
  if mashinka == 9 then carup11() end
  if mashinka == 10 then carupmotor() end
  if mashinka == 11 then perevorot() end
  if mashinka == 12 then carkoles() end
  menuuuvis = -1
  end
  function kosmos()
Z.S("-0.00800000038", F, Cd|Ca|O)
if #Result > 0 then
gg.editAll("2.5", F)
gg.sleep(100)
gg.editAll("-0.00800000038", F)
gg.clearResults()
abc()
car()
end
end
  function _car_logic(state_var, is_on)
    Z.S("4812096201845506048", Q, Ca|O|Cd)
    if is_on then
        Z.W("0", 0x1C, D, true)
        Z.W("0", 0x20, D, true)
        abc()
    else
        Z.W("861939648", 0x1C, D, false)
        Z.W("-1315709440", 0x20, D, false)
        cba()
    end
    gg.clearResults()
    car()
    end
function carkoles()
    carkoles1 = (carkoles1 == "❍⊃ ") and "⊂❍ " or "❍⊃ "
    if carkoles1 == "⊂❍ " then gg.clearList() end
    _car_logic(carkoles1, carkoles1 == "⊂❍ ")
end
function perevorot()
    perevorot1 = (perevorot1 == "❍⊃ ") and "⊂❍ " or "❍⊃ "
    if perevorot1 == "⊂❍ " then gg.clearList() end
    _car_logic(perevorot1, perevorot1 == "⊂❍ ")
end
  function shcars()local s=shcar=="❍⊃ ";shcar=s and"⊂❍ "or"❍⊃ ";Z.S("4575243612898721792",Q,Cd|O);Z.W(s and 2.5 or 0.00001,-0x8,F);gg.clearResults();if s then abc()else cba()end;car()end  
  function gmcarq()local s=gmcarchik=="❍⊃ ";gmcarchik=s and"⊂❍ "or"❍⊃ ";Z.S("4812096201845506048",Q,Ca|Cd|O);Z.W(s and 999999 or 1000,0x5DC,F);gg.clearResults();if s then abc()else cba()end;car()end
function hpcarq()Z.S("4812096201845506048",Q,Ca|Cd|O);Z.W(1000,0x5DC,F);gg.clearResults();abc();car()end
function breakcar()Z.S("4812096201845506048",Q,Ca|Cd|O);Z.W(20,0x5DC,F);gg.clearResults();abc();car()end
function gidra()local s=gidraa=="❍⊃ ";gidraa=s and"⊂❍ "or"❍⊃ ";Z.S("-4647714812178464768",Q,Cd|O|Ca);Z.W(s and 655361 or -16777215,0x160,D,false);gg.clearResults();if s then abc()else cba()end;car()end
function nitrolol()local s=nitr=="❍⊃ ";nitr=s and"⊂❍ "or"❍⊃ ";gg.clearList();Z.S("-4647714812178464768",Q,Cd|O|Ca);Z.W(s and 24772608 or 24772608,0x2C,D,s);Z.W(s and -2145353216 or -2145353216,0x634,D,s);if not s then gg.clearList()end;gg.clearResults();if s then abc()else cba()end;car()end
function carupmotor()local s=upmotor=="❍⊃ ";upmotor=s and"⊂❍ "or"❍⊃ ";Z.S("4812096201845506048",Q,Ca|O|Cd);Z.W(s and -0.00179999997 or 0.0013,0x64,F);gg.clearResults();if s then abc()else cba()end;car()end
function carup11()Z.S("-0.00800000038",F,Cd|O|Ca);gg.editAll("1.0",F);gg.setVisible(false) gg.sleep(100);gg.editAll("-0.00800000038",F);gg.clearResults();abc()end
function mopedsh()local s=mopsh=="❍⊃ ";mopsh=s and"⊂❍ "or"❍⊃ ";Z.S(s and"4539628425391341620"or"4539628427538825268",Q,Ca|O|Cd);gg.editAll(s and"4539628427538825268"or"4539628425391341620",Q);gg.clearResults();if s then gg.toast("MADDY  ·  Press brake to accelerate")abc()else cba()end;car()end

--╔═════════════════╗
--║    VISUAL MODS        ║
--╚═════════════════╝

local chamsiwhite = "❍⊃ "
local chamsired = "❍⊃ "
local fovv = "❍⊃ "
local ulfovq = "❍⊃ "
local esplol = "❍⊃ "
local invwal = "❍⊃ "
function visualy()
menuuuvis = 0
  visuall = gg.choice ({
   MUI.sw("ESP On Names", esplol),
   MUI.sw("White Chams", chamsiwhite),
   MUI.sw("Red Chams", chamsired),
   MUI.sw("Wide FOV", fovv),
   MUI.sw("Ultra Wide FOV", ulfovq),
   MUI.go("Change Login"),
   MUI.go("Change Nick"),
   MUI.sw("Invisible Walls", invwal)},nil,MUI.head("VISUAL", MUI.n_visual()))
  
  if not visuall then mainMenu() end
  if visuall == 1 then esphack() end 
  if visuall == 2 then chamsw() end 
  if visuall == 3 then chamsr() end 
  if visuall == 4 then fov() end 
  if visuall == 5 then ulfov() end 
  if visuall == 6 then chanlog() end 
  if visuall == 7 then channick() end 
  if visuall == 8 then inviswall() end 
  menuuuvis = -1
  end
  function chamsw()local s=chamsiwhite=="❍⊃ ";chamsiwhite=s and"⊂❍ "or"❍⊃ ";Z.S("1132462073",Q,Cd|O);Z.W(s and 1.999111188 or 0.00392156886,-4,F);gg.clearResults();if s then abc()else cba()end;visualy()end
  function chamsr()local s=chamsired=="❍⊃ ";chamsired=s and"⊂❍ "or"❍⊃ ";Z.S("1132462073",Q,Cd|O);Z.W(s and -1.999111188 or 0.00392156886,-4,F);gg.clearResults();if s then abc()else cba()end;visualy()end
  function fov()local s=fovv=="❍⊃ ";fovv=s and"⊂❍ "or"❍⊃ ";Z.S("4252262742350898174",Q,Cd|O);Z.W(s and"90"or"70",0xC,F);gg.clearResults();if s then abc()else cba()end;visualy()end
  function ulfov()local s=ulfovq=="❍⊃ ";ulfovq=s and"⊂❍ "or"❍⊃ ";Z.S("4252262742350898174",Q,Cd|O);Z.W(s and"110"or"70",0xC,F);gg.clearResults();if s then abc()else cba()end;visualy()end
  function esphack()local s=esplol=="❍⊃ ";esplol=s and"⊂❍ "or"❍⊃ ";Z.S("5638878673340727297",Q,A|O);Z.W(s and"199.90909090909"or"30.0101010101",-60,F);Z.W(s and"199.90909090909"or"30.0101010101",-56,F);gg.clearResults();if s then abc()else cba()end;visualy()end
  function inviswall()local s=invwal=="❍⊃ ";invwal=s and"⊂❍ "or"❍⊃ ";Z.S("77190601328179",F,Xa|O|Cd);Z.W(s and -4.99384990408 or 0.90375937,0x14,F);gg.clearResults();if s then abc()else cba()end;visualy()end
  
  function channick()local i1=gg.prompt({"Current nick"},{"Nick_Name"},{"text"})if not i1 then return visualy()end local i2=gg.prompt({"Desired nick"},{"Nick_Name"},{"text"})if not i2 then return visualy()end gg.clearResults();gg.setRanges(Jh|A);gg.searchNumber(":"..i1[1],4)if gg.getResultCount()>0 then gg.getResults(99999) gg.editAll(":"..i2[1],4);abc()else qwea()end gg.clearResults()visualy()end
  
function chanlog()local i1=gg.prompt({"Current login"},{"Login"},{"text"})if not i1 then return visualy()end local i2=gg.prompt({"Desired login"},{"Login"},{"text"})if not i2 then return visualy()end gg.clearResults();gg.setRanges(Jh|A);gg.searchNumber(":"..i1[1],4)if gg.getResultCount()>0 then gg.getResults(99999) gg.editAll(":"..i2[1],4);abc()else qwea()end gg.clearResults()visualy()end
--╔═════════════════════╗
--║     WEAPON MODS           ║
--╚═════════════════════╝
local shshq = "❍⊃ "
local sc = "❍⊃ "
local fsk = "❍⊃ "
local avty = "❍⊃ "
local alertr = "❍⊃ "
function gun()
menuuuvis = 0
local MADDY_Gun = gg.choice ({
 MUI.go("Give Weapon"),
 MUI.go("Give Ammo"),
 MUI.go("Clear Slots"),
 MUI.go("Freeze Slots"),
 MUI.go("Anti-Reload"),
 MUI.go("Infinite Ammo"),
 MUI.go("Firerate Without Cooldown"),
 MUI.sw("Aim Speed", shshq),
 MUI.sw("No Spread", sc),
 MUI.sw("Farm Skills", fsk),
 MUI.sw("Assist +C", avty),
 MUI.sw("Firerate + Speed", alertr)},nil,MUI.head("WEAPONS", MUI.n_weapons())) 

if not MADDY_Gun then mainMenu() end
if MADDY_Gun == 1 then givegun() end 
if MADDY_Gun == 2 then dupept() end 
if MADDY_Gun == 3 then cleanslot() end 
if MADDY_Gun == 4 then freezeslot() end 
if MADDY_Gun == 5 then antirelo() end 
if MADDY_Gun == 6 then besk() end 
if MADDY_Gun == 7 then rapidik() end 
if MADDY_Gun == 8 then shlool() end 
if MADDY_Gun == 9 then scat() end 
if MADDY_Gun == 10 then farmsk() end 
if MADDY_Gun == 11 then avtoq() end 
if MADDY_Gun == 12 then scor2() end 
menuuuvis = -1
end
function rapidik()
    local p = gg.prompt({"Speed [0.3;0.9]"}, nil, {"number"})
        if not p then return gun() end
    
    Z.S("4584664420663165927", Q, Ca|O|Cd)
    
    if #Result > 0 then
        local offs = {16, 28, 240, 252}
        for _, o in ipairs(offs) do 
            Z.W(p[1], o, F)
        end
        abc()
    else
        qwea()
    end
    
    fg.clean()
    gun()
end
function shlool()
    if shshq == "❍⊃ " then
        shshq = "⊂❍ "
        local p = gg.prompt({"Speed [1;100]"}, nil, {"number"})
        if not p then return gun() end
        
        Z.S("4584664420663165927", Q, Ca|O|Cd)
        Z.W(p[1], 8, F)
        Z.W(p[1], 232, F)
        abc()
    else
        shshq = "❍⊃ "
        Z.S("4584664420663165927", Q, Ca|O|Cd)
        Z.W(1.2, 8, F)
        Z.W(1.2, 232, F)
        cba()
    end
    fg.clean()
    gun()
end
function scat()
local _c=(sc=="❍⊃ ")local _o,_m="1120403456","1119748096"
Z.S(_c and _o or _m,D,Ca|O|Cd)
if #Result~=0 then gg.editAll(_c and _m or _o,D)if _c then sc="⊂❍ " gg.clearResults() abc()else sc="❍⊃ " gg.clearResults() cba()end else gg.clearResults() qwea()end
gun()end
function farmsk()
local _f=(fsk=="❍⊃ ")local _o,_m="4 489 188 110 487 257 088","4 489 188 110 535 131 456"
Z.S(_f and _o or _m,Q,Ca|O|Cd)
if #Result~=0 then gg.editAll(_f and _m or _o,Q)if _f then fsk="⊂❍ " gg.clearResults() abc()else fsk="❍⊃ " gg.clearResults() cba()end else gg.clearResults() qwea()end
gun()end
function avtoq()
local _a=(avty=="❍⊃ ")local _o,_m="4 489 188 110 487 257 088","4 489 188 110 489 300 000"
Z.S(_a and _o or _m,Q,Ca|O|Cd)
if #Result~=0 then gg.editAll(_a and _m or _o,Q)if _a then avty="⊂❍ " gg.clearResults() abc()else avty="❍⊃ " gg.clearResults() cba()end else gg.clearResults() qwea()end
gun()end
function scor2()
local _s=(alertr=="❍⊃ ")local _o,_m="4 489 188 110 487 257 088","4 489 188 110 516 131 456"
Z.S(_s and _o or _m,Q,Ca|O|Cd)
if #Result~=0 then gg.editAll(_s and _m or _o,Q)if _s then alertr="⊂❍ " gg.clearResults() abc()else alertr="❍⊃ " gg.clearResults() cba()end else gg.clearResults() qwea()end
gun()end
function cleanslot()
    if not hookPLAYER("+192", D, 0, false) then return gun() end
    hookPLAYER("+256", D, 0, false)
    hookPLAYER("+288", D, 0, false)
    hookPLAYER("+224", D, 0, false)
    hookPLAYER("+320", D, 0, false)
    hookPLAYER("+352", D, 0, false)
    abc()
    gun()
end

local relodgper = "❍⊃ " 
local relom4per = "❍⊃ "
local reloakper = "❍⊃ "
local relompper = "❍⊃ "
                function antirelo()
                menuuuvis = 0
                local MADDY_66666 = gg.choice ({
                     MUI.sw("Deagle", relodgper),
                     MUI.sw("M4", relom4per),
                     MUI.sw("AK-47", reloakper),
                     MUI.sw("MP-5", relompper)},nil,MUI.head("WEAPONS   ›   ANTI-RELOAD", MUI.count(relodgper, relom4per, reloakper, relompper))) 
                
                if not MADDY_66666 then gun() end
                if MADDY_66666 == 1 then antirelodg() end 
                if MADDY_66666 == 2 then antirelom4() end 
                if MADDY_66666 == 3 then antireloak() end 
                if MADDY_66666 == 4 then antirelomp() end 
                menuuuvis = -1
                end
                function antirelomp()
    if relompper == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+264", D, 50, true) then return gun() end
        relompper = "⊂❍ "
        abc()
    else
        relompper = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function antireloak()
    if reloakper == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+296", D, 50, true) then return gun() end
        reloakper = "⊂❍ "
        abc()
    else
        reloakper = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function antirelom4()
    if relom4per == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+296", D, 50, true) then return gun() end
        relom4per = "⊂❍ "
        abc()
    else
        relom4per = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function antirelodg()
    if relodgper == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+200", D, 22, true) then return gun() end
        relodgper = "⊂❍ "
        abc()
    else
        relodgper = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

local bdg = "❍⊃ "
local bmka = "❍⊃ "
local bkal = "❍⊃ "
local bdrobq = "❍⊃ "
local bmp5q = "❍⊃ "
function besk()
menuuuvis = 0
local MADDY_313 = gg.choice ({
                     MUI.sw("Deagle", bdg),
                     MUI.sw("M4", bmka),
                     MUI.sw("AK-47", bkal),
                     MUI.sw("Shotgun", bdrobq),
                     MUI.sw("MP-5", bmp5q)},nil,MUI.head("WEAPONS   ›   INFINITE AMMO", MUI.count(bdg, bmka, bkal, bdrobq, bmp5q))) 

if not MADDY_313 then gun() end
if MADDY_313 == 1 then bdgq() end 
if MADDY_313 == 2 then bmkk() end 
if MADDY_313 == 3 then bkalq() end 
if MADDY_313 == 4 then bdrobe() end 
if MADDY_313 == 5 then bmpsh() end 
menuuuvis = -1
end

function bdgq()
    if bdg == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+204", D, "", true) then return gun() end
        bdg = "⊂❍ "
        abc()
    else
        bdg = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function bmkk()
    if bmka == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+300", D, "", true) then return gun() end
        bmka = "⊂❍ "
        abc()
    else
        bmka = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function bkalq()
    if bkal == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+300", D, "", true) then return gun() end
        bkal = "⊂❍ "
        abc()
    else
        bkal = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function bmpsh()
    if bmp5q == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+268", D, "", true) then return gun() end
        bmp5q = "⊂❍ "
        abc()
    else
        bmp5q = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function bdrobe()
    if bdrobq == "❍⊃ " then
        gg.clearList()
        if not hookPLAYER("+224", D, "", true) then return gun() end
        bdrobq = "⊂❍ "
        abc()
    else
        bdrobq = "❍⊃ "
        gg.clearList()
        cba()
    end
    gun()
end

function dupept()
        menuuuvis = 0
        MADDY_6666 = gg.choice ({
             MUI.go("Deagle"),
             MUI.go("Glock"),
             MUI.go("M4"),
             MUI.go("AK-47"),
             MUI.go("MP-5"),
             MUI.go("Sniper"),
             MUI.go("Shotgun")},nil,MUI.head("WEAPONS   ›   GIVE AMMO", "Select a weapon")) 
        
        if not MADDY_6666 then gun() end
        if MADDY_6666 == 1 then dupedg() end 
        if MADDY_6666 == 2 then dupeglock() end 
        if MADDY_6666 == 3 then dupem4() end 
        if MADDY_6666 == 4 then dupeak() end 
        if MADDY_6666 == 5 then dupemp() end 
        if MADDY_6666 == 6 then dupevint() end 
        if MADDY_6666 == 7 then dupeshotik() end 
        menuuuvis = -1
        end
        
            function dupevint()
    local givptdg7 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg7 then return dupept() end
    if not hookPLAYER("+332", D, givptdg7[1], false) then gg.clearResults() return dupept() end
    abc()
    dupept()
end

function dupeshotik()
    local givptdg6 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg6 then return dupept() end
    if not hookPLAYER("+236", D, givptdg6[1], false) then gg.clearResults() return dupept() end
    abc()
    dupept()
end

function dupeglock()
    local givptdg5 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg5 then return dupept() end
    if not hookPLAYER("+204", D, givptdg5[1], false) then gg.clearResults() return dupept() end
    abc()
    dupept()
end

function dupemp()
    local givptdg4 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg4 then return dupept() end
    if not hookPLAYER("+268", D, givptdg4[1], false) then gg.clearResults() return dupept() end
    abc()
    dupept()
end

function dupem4()
    local givptdg3 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg3 then return dupept() end
    if not hookPLAYER("+300", D, givptdg3[1], false) then gg.clearResults() return dupept() end
    abc()
    dupept()
end

function dupeak()
    local givptdg2 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg2 then return dupept() end
    if not hookPLAYER("+300", D, givptdg2[1], false) then gg.clearResults() return dupept() end
    abc()
    dupept()
end

function dupedg()
    local givptdg1 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg1 then return dupept() end
    if not hookPLAYER("+204", D, givptdg1[1], false) then gg.clearResults() return dupept() end
    abc()
    dupept()
end

frzsl1 = "❍⊃ "
frzsl2 = "❍⊃ "
frzsl3 = "❍⊃ "
frzsl4 = "❍⊃ "
frzsl5 = "❍⊃ "
frzsl6 = "❍⊃ "
frzsl7 = "❍⊃ "
function freezeslot()
        menuuuvis = 0
        local MADDY_ = gg.choice ({
             MUI.sw("Deagle", frzsl1),
             MUI.sw("Glock", frzsl2),
             MUI.sw("M4", frzsl3),
             MUI.sw("AK-47", frzsl4),
             MUI.sw("MP-5", frzsl5),
             MUI.sw("Sniper", frzsl6),
             MUI.sw("Shotgun", frzsl7)},nil,MUI.head("WEAPONS   ›   FREEZE SLOTS", MUI.count(frzsl1, frzsl2, frzsl3, frzsl4, frzsl5, frzsl6, frzsl7))) 
        
        if not MADDY_ then gun() end
        if MADDY_ == 1 then freezeslotq1() end 
        if MADDY_ == 2 then freezeslotq2() end 
        if MADDY_ == 3 then freezeslotq3() end 
        if MADDY_ == 4 then freezeslotq4() end 
        if MADDY_ == 5 then freezeslotq5() end 
        if MADDY_ == 6 then freezeslotq6() end 
        if MADDY_ == 7 then freezeslotq7() end 
        menuuuvis = -1
        end
        
function _frz(n, o1, v1, o2)
    if _G[n] == nil then _G[n] = "❍⊃ " end
    
    local _f = (_G[n] == "❍⊃ ")
    gg.clearList()
    
    if _f then
        if not hookPLAYER(o1, D, v1, true) or not hookPLAYER(o2, D, "", true) then gg.clearResults() return freezeslot() 
        end
        _G[n] = "⊂❍ " 
        abc()
    else
        _G[n] = "❍⊃ " 
        gg.clearList()
        gg.clearResults()
        cba()
    end
    gg.clearResults()
    freezeslot()
end

function freezeslotq7() _frz("frzsl7", "+224", 25, "+236") end
function freezeslotq6() _frz("frzsl6", "+320", 34, "+332") end
function freezeslotq5() _frz("frzsl5", "+256", 29, "+268") end
function freezeslotq4() _frz("frzsl4", "+288", 30, "+300") end
function freezeslotq3() _frz("frzsl3", "+288", 31, "+300") end
function freezeslotq2() _frz("frzsl2", "+192", 22, "+204") end
function freezeslotq1() _frz("frzsl1", "+192", 24, "+204") end

function givegun()
        menuuuvis = 0
        local MADDY_Gun1 = gg.choice ({
                     MUI.go("Deagle"),
                     MUI.go("M4"),
                     MUI.go("AK-47"),
                     MUI.go("Shotgun"),
                     MUI.go("MP-5"),
                     MUI.go("Glock"),
                     MUI.go("Sniper No Scope"),
                     MUI.go("Sniper With Scope"),
                     MUI.go("Minigun"),
                     MUI.go("RPG"),
                     MUI.go("Auto RPG"),
                     MUI.go("Other Weapons"),
                     MUI.go("Weapon IDs")},nil,MUI.head("WEAPONS   ›   GIVE WEAPON", "Select a weapon")) 
        
        if not MADDY_Gun1 then gun() end
        if MADDY_Gun1 == 1 then gv11dg() end 
        if MADDY_Gun1 == 2 then gv22m4() end         
        if MADDY_Gun1 == 3 then gv33ak() end 
        if MADDY_Gun1 == 4 then gv44shot() end 
        if MADDY_Gun1 == 5 then gv55mp() end 
        if MADDY_Gun1 == 6 then gv66gl() end 
        if MADDY_Gun1 == 7 then gv77snap() end 
        if MADDY_Gun1 == 8 then gv77snappr() end 
        if MADDY_Gun1 == 9 then gv88minig() end 
        if MADDY_Gun1 == 10 then gv99rpg() end 
        if MADDY_Gun1 == 11 then gv111rpgauto() end 
        if MADDY_Gun1 == 12 then givegun14() end 
        if MADDY_Gun1 == 13 then givegun1488() end
        end

function gv77snappr()
    if not hookPLAYER("+320", D, 34, false) then gg.clearResults() return givegun() end
    local givptdg77 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg77 then return givegun() end
    if not hookPLAYER("+332", D, givptdg77[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv11dg()
    if not hookPLAYER("+192", D, 24, false) then gg.clearResults() return givegun() end
    local givptdg11 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg11 then return givegun() end
    if not hookPLAYER("+204", D, givptdg11[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv22m4()
    if not hookPLAYER("+288", D, 31, false) then gg.clearResults() return givegun() end
    local givptdg22 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg22 then return givegun() end
    if not hookPLAYER("+300", D, givptdg22[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv33ak()
    if not hookPLAYER("+288", D, 30, false) then gg.clearResults() return givegun() end
    local givptdg33 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg33 then return givegun() end
    if not hookPLAYER("+300", D, givptdg33[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv44shot()
    if not hookPLAYER("+224", D, 25, false) then gg.clearResults() return givegun() end
    local givptdg44 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg44 then return givegun() end
    if not hookPLAYER("+236", D, givptdg44[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv55mp()
    if not hookPLAYER("+256", D, 29, false) then gg.clearResults() return givegun() end
    local givptdg55 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg55 then return givegun() end
    if not hookPLAYER("+268", D, givptdg55[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv66gl()
    if not hookPLAYER("+192", D, 22, false) then gg.clearResults() return givegun() end
    local givptdg66 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg66 then return givegun() end
    if not hookPLAYER("+204", D, givptdg66[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv77snap()
    if not hookPLAYER("+320", D, 33, false) then gg.clearResults() return givegun() end
    local givptdg89 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg89 then return givegun() end
    if not hookPLAYER("+332", D, givptdg89[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv88minig()
    if not hookPLAYER("+352", D, 38, false) then gg.clearResults() return givegun() end
    local givptdg888 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg888 then return givegun() end
    if not hookPLAYER("+364", D, givptdg888[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv99rpg()
    if not hookPLAYER("+352", D, 35, false) then gg.clearResults() return givegun() end
    local givptdg99 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg99 then return givegun() end
    if not hookPLAYER("+364", D, givptdg99[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function gv111rpgauto()
    if not hookPLAYER("+352", D, 36, false) then gg.clearResults() return givegun() end
    local givptdg111 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg111 then return givegun() end
    if not hookPLAYER("+364", D, givptdg111[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun()
end

function givegun14()
    local givptdg14888 = gg.prompt({"Weapon ID [1;46]"}, nil, {[1]="number"})
    if not givptdg14888 then return givegun() end
    if not hookPLAYER("+192", D, givptdg14888[1], false) then gg.clearResults() return givegun() end
    
    local givptdg1488 = gg.prompt({"Ammo count [1;9900]"}, nil, {[1]="number"})
    if not givptdg1488 then return givegun() end
    if not hookPLAYER("+204", D, givptdg1488[1], false) then gg.clearResults() return givegun() end
    abc()
    givegun() 
end
        function givegun1488()
        gg.alert(MUI.head("WEAPONS   ›   WEAPON IDS", "Use these ids with Other Weapons") .. "\n\n01   Knuckles\n02   Key\n03   Baton\n04   Knife\n05   Bat\n06   Shovel\n07   Cue\n08   Katana\n09   Chainsaw\n10   Double Dildo\n11   Dildo\n12   Vibrator\n13   Silver Vibrator\n14   Flower Bouquet\n15   Staff\n16   Grenade\n17   Tear Gas\n18   Molotov\n22   9mm Pistol\n23   Silenced Pistol\n24   Deagle\n25   Regular Shotgun\n26   Sawed-Off\n27   Auto Shotgun\n28   Uzi\n29   MP5\n30   AK-47\n31   M4\n32   Tec-9\n33   Hunting Rifle\n34   Sniper Rifle\n35   RPG\n36   Rocket Launcher\n37   Flamethrower\n38   Minigun\n39   Satchel\n40   Detonator\n41   Spray Can\n42   Fire Extinguisher\n43   Camera\n44   Night Vision\n45   Thermal Vision\n46   Parachute")
        givegun()
        end


--╔═══════════════════════════════════════════════════════════════════╗
--║                    TELEPORT SYSTEM                                 ║
--╚═══════════════════════════════════════════════════════════════════╝

function teleportByCoords()
    local coords = gg.prompt({"X coordinate", "Y coordinate", "Z coordinate"}, nil, {"number", "number", "number"})
    if not coords then return tpMenu() end
    doTeleport(coords[1], coords[2], coords[3])
    tpMenu()
end

function teleportByMarker()
  hookPLAYER(-4, F, 350)
  local gV, sV, tI = gg.getValues, gg.setValues, table.insert
  while true do
    fg.clean()
    local C, M = {}, {}
    for _, q in ipairs({"13950255104", "5360320512"}) do
      if #C == 0 then
        Z.S(q, Q, O)
        if Result then
          for _, v in ipairs(Result) do
            local c = gV({{address = v.address + 32, flags = F}, {address = v.address + 36, flags = F}, {address = v.address + 40, flags = F}, {address = v.address + 48, flags = F}})
            local x, y, z, o = c[1].value, c[2].value, c[3].value, c[4].value
            if x ~= 0 and y ~= 0 and x > -3000 and x < 3000 and y > -3000 and y < 3000 and z == 0 and o == 1 then
              tI(C, {x, y})
              tI(M, string.format("%02d   X %.1f   ·   Y %.1f", #C, x, y))
            end
          end
        end
      end
    end
    if #C == 0 then
      qwea()
      fg.clean()
      hookPLAYER(-4, F, 100)
      return tpMenu()
    end
    tI(M, MUI.go("Refresh"))
    tI(M, MUI.back())
    local s = gg.choice(M, nil, MUI.head("TELEPORT   ›   MARKER", MUI.num(#C, "marker", "markers") .. "   ·   tap one to teleport"))
    if not s then
      gg.setVisible(false)
      while not gg.isVisible() do gg.sleep(200) end
    elseif M[s] == MUI.back() then
      fg.clean()
      hookPLAYER(-4, F, 100)
      return tpMenu()
    elseif M[s] == MUI.go("Refresh") then
    else
      Z.S("4575657250219098112", Q, Ca | O)
      if Result and #Result > 0 then
        local t = {}
        for i, v in ipairs(Result) do t[i] = {address = v.address + 140, flags = F} end
        t = gV(t)
        for i, v in ipairs(t) do v.value = v.value + 50 end
        sV(t)
        Z.W(C[s][1], 132, F)
        Z.W(C[s][2], 136, F)
        abc()
        fg.clean()
        break -- Yeh raha break
      else
      qwea()
      end
    end
  end
end



FILE_PATH = gg.EXT_STORAGE .. "/MADDY_points.txt"
savedPoints = {}

function loadPoints()
    savedPoints = {}
    local f = io.open(FILE_PATH, "r")
    if f then
        for line in f:lines() do
            local name, x, y, z = line:match("([^|]+)|([^|]+)|([^|]+)|([^|]+)")
            if name then
                table.insert(savedPoints, {name = name, x = tonumber(x), y = tonumber(y), z = tonumber(z)})
            end
        end
        f:close()
    end
end

function savePoints()
    local f = io.open(FILE_PATH, "w")
    if f then
        for _, p in ipairs(savedPoints) do
            f:write(string.format("%s|%.6f|%.6f|%.6f\n", p.name, p.x, p.y, p.z))
        end
        f:close()
    end
end

function getCurrentCoords()
    Z.S("4575657250219098112", Q, Ca|O)
    if not Result or #Result == 0 then
        showError()
        return nil
    end
    local addr = Result[1].address
    local vals = gg.getValues({
        {address = addr + 132, flags = F},
        {address = addr + 136, flags = F},
        {address = addr + 140, flags = F}
    })
    gg.clearResults()
    return vals[1].value, vals[2].value, vals[3].value
end

function managePointsMenu()
    loadPoints()
    local choice = gg.choice({
        MUI.go("Current Coordinates"),
        MUI.go("Save Current Point"),
        MUI.go("My Saved Points"),
        MUI.go("Clear All Points"),
        MUI.back()
    }, nil, MUI.head("TELEPORT   ›   POINTS", MUI.num(#savedPoints, "point", "points") .. " saved"))
    
    if not choice then return tpMenu() end
    if choice == 1 then
        local x, y, z = getCurrentCoords()
        if x then
            local text = string.format("X: %.2f\nY: %.2f\nZ: %.2f", x, y, z)
            local res = gg.alert(MUI.head("TELEPORT   ›   COORDINATES") .. "\n\n" .. text, "Back", "Copy")
            if res == 2 then
                gg.copyText(text)
                toast.success("MADDY  ·  Coordinates copied")
            end
        end
        managePointsMenu()
        
    elseif choice == 2 then
        local x, y, z = getCurrentCoords()
        if x then
            local prompt = gg.prompt({"Point name"}, {"Point " .. os.date("%H:%M")}, {"text"})
            if prompt then
                table.insert(savedPoints, {name = prompt[1], x = x, y = y, z = z})
                savePoints()
                toast.success("MADDY  ·  Point saved  ·  " .. prompt[1])
            end
        end
        managePointsMenu()
        
    elseif choice == 3 then
        viewSavedPoints()
        
    elseif choice == 4 then
        if gg.alert("Delete all saved points?\nThis cannot be undone.", "Delete", "Cancel") == 1 then
            savedPoints = {}
            savePoints()
            toast.success("MADDY  ·  All points cleared")
        end
        managePointsMenu()
        
    elseif choice == 5 then
        tpMenu()
    end
end

function viewSavedPoints()
    if #savedPoints == 0 then
        gg.alert(MUI.head("TELEPORT   ›   POINTS", "No saved points yet") .. "\n\nUse Save Current Point to add one.")
        return managePointsMenu()
    end
    
    local list = {}
    for i, p in ipairs(savedPoints) do
        list[i] = MUI.item(i, p.name)
    end
    list[#list + 1] = MUI.back()
    
    local q = gg.choice(list, nil, MUI.head("TELEPORT   ›   SAVED POINTS", MUI.num(#savedPoints, "point", "points")))
    if not q or q == #list then return managePointsMenu() end
    
    local p = savedPoints[q]
    local action = gg.choice({MUI.go("Teleport"), MUI.go("Delete"), MUI.back()}, nil, MUI.head("SAVED POINT", p.name))
    
    if action == 1 then
        doTeleport(p.x, p.y, p.z)
    elseif action == 2 then
        table.remove(savedPoints, q)
        savePoints()
        toast.success("MADDY  ·  Point deleted")
        viewSavedPoints()
    else
        viewSavedPoints()
    end
end

--╔═══════════════════════════════════════════════════════════════════╗
--║                    TELEPORT LOCATIONS                              ║
--╚═══════════════════════════════════════════════════════════════════╝

local publicPlaces = {
    {name = 'Auto School', x = 486, y = 2276, z = 12},
    {name = 'Military Base', x = 1915, y = 2302, z = 15},
    {name = 'Bank South', x = 2372, y = -2142, z = 23},
    {name = 'Bank Arzamas', x = -143, y = 593, z = 12},
    {name = 'Bank Batyrevo', x = 1850, y = 2042, z = 16},
    {name = 'Church', x = 1877, y = 1166, z = 31},
    {name = 'Car Market', x = 878, y = 2236, z = 19},
    {name = 'Post Office', x = 801, y = 1349, z = 15}
}

local hiddenteleports = {
  {name = 'Admin Zone', x = -700, y = -2450, z = 1201},
  {name = 'Go Out from Jail', x = 644.01, y = 1049.21, z = 1208.26},
  {name = 'Prison', x = -1830, y = -2870, z = 45},
  {name = 'Military Base #1', x = -1092.7, y = -2539.2, z = 28.6},
  {name = 'Military Base #2', x = -1002.8, y = -2497.4, z = 28.1},
  {name = 'TV Tower', x = 2130, y = -1968, z = 270},
  {name = 'Hospital Roof ARZ', x = 382, y = 1332, z = 128},
  {name = 'Government Roof', x = -102, y = 817, z = 79},
  {name = 'Casino Roof', x = 331, y = 2800, z = 33},
  {name = 'Military Roof', x = 1816, y = 1792, z = 34},
  {name = 'Kremlin', x = -2480, y = 1675, z = 53},
  {name = 'Fam War Main Entrance', x = 1501.1, y = -301.6, z = 7.3},
  {name = 'Fam War Point #1', x = 1484.3, y = -119.9, z = 10.3},
  {name = 'Fam War Point #2', x = 1564.3, y = 7.0, z = 7.3},
  {name = 'Fam War Point #3', x = 1620.5, y = -144, z = 7.3},
  {name = 'Fam War Point #4', x = 1564.2, y = -131.7, z = 7.3},
  {name = 'Building Roof', x = 1566.5, y = -200.9, z = 25.6},
  {name = 'MU Port', x = 2493.50, y = 354.48, z = 29.73}
}

local stations = {
    {name = 'Bus Station Arzamas', x = -561, y = 931, z = 12},
    {name = 'Bus Station South', x = 2734, y = -2447, z = 22},
    {name = 'Bus Station Batyrevo', x = 1813, y = 2513, z = 15},
    {name = 'Train Station South', x = 2499, y = -2145, z = 22}
}

local parking = {
  {name = 'Economy Parking', x = 2323, y = -1800, z = 22},
  {name = 'Comfort Parking', x = 2202.15, y = 2884.95, z = 26.58},
  {name = 'Premium Parking', x = 602, y = 998, z = 12},
  {name = 'Scooter Parking', x = 340, y = 479, z = 12.3},
  {name = 'Arzamas Parking', x = 420, y = 584, z = 12},
  {name = 'Batyrevo Parking', x = 1748, y = 2464, z = 15},
  {name = 'Yuzhany Parking', x = 2441, y = -1734, z = 23},
  {name = 'Edovo Parking', x = -2390, y = 2686, z = 39.1},
  {name = 'Reactor Parking', x = 711, y = 525, z = 13}
}

local government = {
    {name = 'Government Building', x = -79, y = 839, z = 17},
    {name = 'Military Unit', x = 1872, y = 1723, z = 15},
    {name = 'Hospital Arzamas', x = 361, y = 1332, z = 13},
    {name = 'Hospital South', x = 2118, y = -2386, z = 23},
    {name = 'Police Arzamas', x = 153, y = 1265, z = 12},
    {name = 'Police South', x = 2582, y = -2421, z = 23},
    {name = 'FSB', x = 1896, y = -1995, z = 31}
}

local criminal = {
    {name = 'Tambov Gang', x = 2425, y = -1922, z = 22},
    {name = 'Kurgan Gang', x = 2285, y = 1369, z = 11},
    {name = 'Black Market', x = -2249, y = 245, z = 24.5},
    {name = 'Orekhov Gang', x = 481.89, y = 742.55, z = 12.00},
    {name = 'Sawmill Bizzwar', x = -1043.95, y = -2464.63, z = 28.48},
    {name = 'Fam War Entrance', x = 1503.80, y = -297.03, z = 7.34}
}

local starterJobs = {
    {name = 'Tesla Factory', x = -2547, y = 534, z = 9},
    {name = 'Twix Factory', x = 2242, y = 2146, z = 16.2},
    {name = 'Mine', x = -1109, y = 1363, z = 31.5},
    {name = 'Farm', x = 950, y = -910, z = 39}
}

local jobs = {
    {name = 'Taxi', x = 757, y = 757, z = 11},
    {name = 'Bus Driver', x = 786, y = 750, z = 12},
    {name = 'Postman', x = 801, y = 1349, z = 15},
    {name = 'Mechanic', x = 2132, y = -1847, z = 20},
    {name = 'Road Service South', x = 2648, y = -1902, z = 22},
    {name = 'Road Service Arzamas', x = 636, y = 897, z = 12},
    {name = 'Tesla Factory', x = -2671.84, y = 521.80, z = 8.75}
}

local entertainment = {
    {name = 'Grand Casino', x = 327, y = 2762, z = 8},
    {name = 'Auction', x = 443, y = -393, z = 9},
    {name = 'Bookmaker', x = 280, y = 2717, z = 8},
    {name = 'Drift Zone', x = 2333, y = 1182, z = 20},
    {name = 'Park', x = 330, y = 2670, z = 8},
    {name = 'Tss Roof', x = 736.66, y = 534.28, z = 22.57}
}

local airdropMADDY = {
    {name = 'Arzamas Opposite Bus Job', x = 738, y = 809, z = 12},
    {name = 'Arzamas Opposite Hospital', x = 254, y = 1433, z = 12},
    {name = 'Arzamas Near Fountain', x = 59.86, y = 115.10, z = 10.21},
    {name = 'Arzamas Bus Terminal', x = -435.40, y = 954.89, z = 12.15},
    {name = 'Outside Government House', x = 71.16, y = 865.27, z = 14.65},
    {name = 'Near Royal Fam House', x = -422.17, y = 1242.90, z = 17.60},
    {name = 'Mine', x = -1067.73, y = 1326.70, z = 31.72},
    {name = 'Mine Road Opposite', x = -1087.75, y = 1573.69, z = 35.25},
    {name = 'Near Elite Road Truck Job', x = -1543.19, y = 2493.87, z = 42.64},
    {name = 'Elite Village Bridge', x = -1941.45, y = 1743.18, z = 113.51},
    {name = 'Elite Village Top', x = -1682.69, y = 1488.33, z = 230.90},
    {name = 'Edovo Parking', x = -2368.34, y = 2717.94, z = 37.80},
    {name = 'Ground', x = -2519.84, y = 1634.87, z = 53.39},
    {name = 'Tesla Factory', x = -2671.84, y = 521.80, z = 8.75},
    {name = 'Lyth', x = -1749.56, y = -261.11, z = 51.32},
    {name = 'Garbage Road', x = -1956.76, y = -1214.84, z = 49.04},
    {name = 'Busevo', x = -508.73, y = -1677.10, z = 40.81},
    {name = 'Sawmill Bizzwar', x = -1043.95, y = -2464.63, z = 28.48},
    {name = 'Container Auction', x = 283.29, y = -384.27, z = 8.87},
    {name = 'Out Side Farm', x = 848.24, y = -761.71, z = 40.24},
    {name = 'Tower', x = 500.97, y = -2485.05, z = 34.51},
    {name = 'Yuz Building', x = 2559.01, y = -2190.47, z = 21.97},
    {name = 'Yuz KFC', x = 2229.02, y = -1926.52, z = 21.77},
    {name = 'Yuz Buyer', x = 2307.70, y = -1971.28, z = 21.98},
    {name = 'ARZ to Yuz Bridge', x = 2733.16, y = -959.24, z = 23.60},
    {name = 'Arzamas Sea Road', x = 2503.96, y = 716.95, z = 29.56},
    {name = 'Near Kurgan', x = 2419.89, y = 1361.77, z = 11.33},
    {name = 'Batyrevo Restaurant', x = 1867.87, y = 2242.97, z = 15.27},
    {name = 'Opposite Casino', x = 328.25, y = 2665.45, z = 7.84}
}

local heliClubs = {
    {name = 'Heli Club South', x = -2691, y = -1647, z = 23},
    {name = 'Heli Club Arzamas', x = 528, y = 1761, z = 12}
}

local buyers = {
    {name = 'Buyer South', x = 2331, y = -1989, z = 22},
    {name = 'Buyer Arzamas', x = -89, y = 961, z = 12}
}

local businesses = {
    {name = '24/7 Shop', x = -2386.05, y = 257.38, z = 23.72},
    {name = 'Restaurant', x = -280, y = -1765.3, z = 41},
    {name = 'Gun Shop', x = 112.51, y = 574.09, z = 13.26},
    {name = 'Clothes Shop', x = 1945, y = 2066, z = 15.7},
    {name = 'Gas Station', x = 2328, y = -762, z = 14}
}

local quarries = {
    {name = 'Arzamas Quarry', x = -611, y = 1433, z = 12.50},
    {name = 'Batyrevo Quarry', x = 2605, y = 2556, z = 12.40},
    {name = 'South Quarry', x = 2053, y = -700, z = 12.40}
}

function showLocations(locations, title)
    local menu = {}
    for i, loc in ipairs(locations) do
        menu[i] = MUI.item(i, loc.name)
    end
    menu[#menu + 1] = MUI.back()
    
    local q = gg.choice(menu, nil, MUI.head("TELEPORT   ›   " .. title, MUI.num(#locations, "location", "locations")))
    if not q or q == #menu then return teleportByFootMenu() end
    
    local loc = locations[q]
    if loc and loc.x and loc.y and loc.z then
        doTeleport(loc.x, loc.y, loc.z)
    end
    teleportByFootMenu()
end

function showPublicPlaces() showLocations(publicPlaces, "PUBLIC PLACES") end
function showHiddenTeleports() showLocations(hiddenteleports, "HIDDEN TELEPORTS") end

function showStations() showLocations(stations, "STATIONS") end
function showParking() showLocations(parking, "PARKING LOTS") end
function showGovernment() showLocations(government, "GOVERNMENT") end
function showCriminal() showLocations(criminal, "CRIMINAL") end
function showStarterJobs() showLocations(starterJobs, "STARTER JOBS") end
function showJobs() showLocations(jobs, "JOBS") end
function showEntertainment() showLocations(entertainment, "ENTERTAINMENT") end
function showAirdropMADDY()
 showLocations(airdropMADDY, "AIRDROP BY MADDY") end
function showHeliClubs() showLocations(heliClubs, "HELI CLUBS") end
function showBuyers() showLocations(buyers, "BUYERS") end
function showBusinesses() showLocations(businesses, "BUSINESSES") end
function showQuarries() showLocations(quarries, "QUARRIES") end

function teleportByFootMenu()
    menuuuvis = 0
    local choice = gg.choice({
        MUI.go("Public Places"),
        MUI.go("Hidden Teleports"),
        MUI.go("Stations"),
        MUI.go("Parking Lots"),
        MUI.go("Government"),
        MUI.go("Criminal"),
        MUI.go("Starter Jobs"),
        MUI.go("Jobs"),
        MUI.go("Entertainment"),
        MUI.go("Airdrop By MADDY"),
        MUI.go("Heli Clubs"),
        MUI.go("Buyers"),
        MUI.go("Businesses"),
        MUI.go("Quarries"),
        MUI.go("My Points"),
        MUI.back()
    }, nil, MUI.head("TELEPORT   ›   BY FOOT", "Choose a category"))
    
    if not choice then tpMenu() end
    if choice == 1 then showPublicPlaces()
    elseif choice == 2 then showHiddenTeleports()
    elseif choice == 3 then showStations()
    elseif choice == 4 then showParking()
    elseif choice == 5 then showGovernment()
    elseif choice == 6 then showCriminal()
    elseif choice == 7 then showStarterJobs()
    elseif choice == 8 then showJobs()
    elseif choice == 9 then showEntertainment()
    elseif choice == 10 then showAirdropMADDY()
    elseif choice == 11 then showHeliClubs()
    elseif choice == 12 then showBuyers()
    elseif choice == 13 then showBusinesses()
    elseif choice == 14 then showQuarries()
    elseif choice == 15 then viewSavedPoints()
    elseif choice == 16 then tpMenu()
    end
    menuuuvis = -1
end

function tpMenu()
    menuuuvis = 0
    local choice = gg.choice({
        MUI.go("By Coordinates"),
        MUI.go("By Marker"),
        MUI.go("By Foot"),
        MUI.go("Save / Manage Points"),
        MUI.back()
    }, nil, MUI.head("TELEPORT", "Choose a method"))
    
  if not choice then mainMenu() end
    if choice == 1 then teleportByCoords()
    elseif choice == 2 then teleportByMarker()
    elseif choice == 3 then teleportByFootMenu()
    elseif choice == 4 then managePointsMenu()
    elseif choice == 5 then mainMenu()
    end
    menuuuvis = -1
end

--╔═════════════╗
--║  DEV        ║
--╚═════════════╝

function devMenu()
    local choice = gg.choice({
        MUI.go("YouTube   ·   @MADDY1170"),
        MUI.go("Discord   ·   @MADDY03"),
        MUI.back()
    }, nil, MUI.head("DEVELOPER", "Tap a link to copy and open it"))
    
    if not choice then return mainMenu() end
    if choice == 1 then
        gg.copyText("https://youtube.com/@MADDY1170")
        gg.goURL("https://youtube.com/@MADDY1170")
    elseif choice == 2 then
        gg.copyText("https://dc.me/MADDY03")
        gg.goURL("https://dc.me/MADDY03")
    elseif choice == 3 then
        return mainMenu()
    end
    devMenu()
end


function supportMenu()
    gg.alert(MUI.head("SUPPORT") .. "\n\nSupport the creator\n\nDiscord   ·   MADDY\nYouTube   ·   /@MADDY", "Back")
    return mainMenu()
end

function exitScript()
    if MADDYAimbotRunning then
        MADDYAimbotRunning = false
        MADDYSmoothAimbotOff()
    end
    print("MADDY  ·  script closed")
    gg.setVisible(true)
    os.exit()
    gg.exit()
end

--═══════════════════════════════════════════════════════════════════
-- 💜 MADDY FPS BOOSTER INTEGRATED VARIABLES & FUNCTIONS
--═══════════════════════════════════════════════════════════════════

fps120 = false
pingBoost = false
removeLag = false
smoothGame = false
ultraBoost = false

local F = 16  -- Float
local D = 4   -- Dword
local Ca = 4  -- C++ Data a
local O = -2080896 -- Other

local function msg(s) gg.toast("MADDY  ·  "..s) end
local function msgOff(s) gg.toast("MADDY  ·  "..s) end

local function searchNumber(value, flags, ranges)
    gg.clearResults()
    gg.setRanges(ranges)
    gg.searchNumber(value, flags)
    return gg.getResults(gg.getResultCount())
end

local function setValue(address, value, flags, freeze)
    local t = {{address = address, value = value, flags = flags}}
    if freeze then
        t[1].freeze = true
        gg.addListItems(t)
    else
        gg.setValues(t)
    end
end

-- FPS Booster Functions
function boost120FPS()
    fps120 = not fps120
    if fps120 then
        local success = false
        local targets = {"30", "60", "90"}
        for _, val in ipairs(targets) do
            local res = searchNumber(val, D, Ca|O)
            if res and #res > 0 then
                for i = 1, math.min(20, #res) do setValue(res[i].address, 120, D, true) end
                success = true
            end
        end
        if success then msg("120 FPS boost on") else msg("No FPS values found") fps120 = false end
    else
        gg.clearList()
        msgOff("120 FPS boost off")
    end
    gg.clearResults()
    fpsBoosterMenu()
end

function boostPing()
    pingBoost = not pingBoost
    if pingBoost then
        local res = searchNumber("10000", D, Ca|O)
        if res and #res > 0 then
            for i = 1, math.min(10, #res) do setValue(res[i].address, 10, D, true) end
            msg("Ping boost on")
        else
            msg("No network values found")
            pingBoost = false
        end
    else
        gg.clearList()
        msgOff("Ping boost off")
    end
    gg.clearResults()
    fpsBoosterMenu()
end

function removeGameLag()
    removeLag = not removeLag
    if removeLag then
        local res = searchNumber("1.0", F, Ca|O)
        if res and #res > 0 then
            for i = 1, math.min(30, #res) do setValue(res[i].address, 0.3, F, true) end
            msg("Lag removal on")
        else
            msg("No values found")
            removeLag = false
        end
    else
        gg.clearList()
        msgOff("Lag removal off")
    end
    gg.clearResults()
    fpsBoosterMenu()
end

function fpsBoosterMenu()
    local c = gg.choice({
        MUI.sw("120 FPS Boost", fps120),
        MUI.sw("Ping Boost", pingBoost),
        MUI.sw("Remove Lag", removeLag),
        MUI.back()
    }, nil, MUI.head("FPS BOOSTER", MUI.count(fps120, pingBoost, removeLag)))
    
    if not c then return end
    if c == 1 then boost120FPS()
    elseif c == 2 then boostPing()
    elseif c == 3 then removeGameLag()
    elseif c == 4 then mainMenu()
    end
end

--------------------------------------------------------------------
--  MAIN MENU
--------------------------------------------------------------------

-- live switch counters (read-only views of the existing state variables)
function MUI.n_player() return MUI.count(shv222, mbq, gm4, gm9, gm5, walg, fastkil, hjj, whh, graviq, graviqq) end
function MUI.n_car() return MUI.count(gmcarchik, nitr, gidraa, shcar, mopsh, upmotor, perevorot1, carkoles1) end
function MUI.n_visual() return MUI.count(esplol, chamsiwhite, chamsired, fovv, ulfovq, invwal) end
function MUI.n_weapons()
    return MUI.count(shshq, sc, fsk, avty, alertr,
        relodgper, relom4per, reloakper, relompper,
        bdg, bmka, bkal, bdrobq, bmp5q,
        frzsl1, frzsl2, frzsl3, frzsl4, frzsl5, frzsl6, frzsl7)
end
function MUI.n_aim()
    local n = 0
    for _, v in ipairs(aim_st) do if v.s then n = n + 1 end end
    return n
end
function MUI.n_fps() return MUI.count(fps120, pingBoost, removeLag) end

function mainMenu()
    menuuuvis = 0
    local pl, ca, we, vi, ai, fp = MUI.n_player(), MUI.n_car(), MUI.n_weapons(), MUI.n_visual(), MUI.n_aim(), MUI.n_fps()
    local total = pl + ca + we + vi + ai + fp
    local choice = gg.choice({
        MUI.go("Player")      .. MUI.badge(pl),
        MUI.go("Vehicle")     .. MUI.badge(ca),
        MUI.go("Weapons")     .. MUI.badge(we),
        MUI.go("Visual")      .. MUI.badge(vi),
        MUI.go("Teleport"),
        MUI.go("Aimbot")      .. MUI.badge(ai),
        MUI.go("FPS Booster") .. MUI.badge(fp),
        MUI.go("Developer"),
        MUI.go("Support"),
        "■   Exit"
    }, nil, MUI.head("CONTROL PANEL", total > 0 and (total .. " active") or "All off"))
    
    if not choice then return end
    
    if choice == 1 then player()
    elseif choice == 2 then car()
    elseif choice == 3 then gun()
    elseif choice == 4 then visualy()
    elseif choice == 5 then tpMenu()
    elseif choice == 6 then MaddyAimMenu()
    elseif choice == 7 then fpsBoosterMenu()
    elseif choice == 8 then devMenu()
    elseif choice == 9 then supportMenu()
    elseif choice == 10 then exitScript()
    end
    
    menuuuvis = -1
end
function abc()
    gg.toast("MADDY  ·  Applied")
end

function cba()
    gg.toast("MADDY  ·  Disabled")
end

function qwea()
    gg.toast("MADDY  ·  Not found")
end


--╔════════════════════════╗
--║       SCRIPT START                                                            ║
--╚════════════════════════╝

toast.success("MADDY  ·  Loaded", 4)
gg.sleep(1500) 

while true do
    if gg.isVisible(true) then
        menuuuvis = 1
        gg.setVisible(false)
    end
    if menuuuvis == 1 then
        mainMenu()
    end
    gg.sleep(100)
end


    

