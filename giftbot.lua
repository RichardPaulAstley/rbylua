local version = memory.readword(0x14e)
local base_address
local atkdef
local spespc

if version == 0x9f12 then
	print("Crystal detected")
  base_address = 0xdcd7
else
	print(string.format("unknown version, code: %4x", version))
  print("script stopped")
  return
end

local size = memory.readbyte(base_address)-1
local dv_addr = (base_address+0x1D)+size*0x30
 
 
function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0xA2 or atkdef == 0xA3 or atkdef == 0xA6 or atkdef == 0xA7 or atkdef == 0xAA or atkdef == 0xAB or atkdef == 0xAE or atkdef == 0xAF then
            return true
        else
            return false
        end
    else
        return false
    end
end
 
state = savestate.create()
savestate.save(state)
 
while true do
   
    emu.frameadvance()
    savestate.save(state)
    i=0
    while i < 20 do
        joypad.set(1, {A=true})
        vba.frameadvance()
        
	i=i+1
    end
    atkdef = memory.readbyte(dv_addr)
    spespc = memory.readbyte(dv_addr+1)
    --print(i)
    print(atkdef)
    print(spespc)
    if shiny(atkdef,spespc) then
        print("Shiny!!! Script stopped.")
        print(string.format("atk: %d", math.floor(atkdef/16)))
        print(string.format("def: %d", atkdef%16))
        print(string.format("spe: %d", math.floor(spespc/16)))
        print(string.format("spe: %d", spespc%16))
        savestate.save(state)
        break
    else
		print("discarded")
        savestate.load(state)
    end
   
   
end
