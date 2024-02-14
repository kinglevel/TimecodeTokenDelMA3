local pluginName     = select(1,...);
local componentName  = select(2,...);
local signalTable    = select(3,...);
local my_handle      = select(4,...);
----------------------------------------------------------------------------------------------------------------


local PlugTitle = "Timecode Token Deleter"
local name = "timecode_mididel"

-- Almost never tested.
-- No support is given.

-- Github: https://github.com/kinglevel
-- Instagram: @kinglevel
-- Please commit or post updates for the community


--[[
                      /mMNh-
                      NM33My
                      -ydds`
                        /.
                        ho
         +yy/          `Md           +yy/
        .N33N`         +MM.         -N33N`
         -+o/          hMMo          o++-
            d:        `MMMm         oy
-:.         yNo`      +MMMM-       yM+        .:-`
d33N:       /MMh.     dMMMMs     -dMM.       :N33d
+ddd:       `MMMm:   .MMMMMN    /NMMd        :hdd+
  ``hh+.     hMMMN+  +MMMMMM: `sMMMMo     -ody `
    -NMNh+.  +MMMMMy`d_SUM_My.hMMMMM-  -odNMm`
     /MMMMNh+:MMMMMMmMMMMMMMNmMMMMMN-odNMMMN-
      oMMMMMMNMMMMMMMMMMMMMMMMMMMMMMNMMMMMM/
       hMMMMMMMMM---LEDvard---MMMMMMMMMMMMo
       `mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMh
        .NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm`
         :mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-
        `://////////////////////////////.
    -+ymMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNho/.

"Vision will blind. Severance ties. Median am I. True are all lies"


README: https://github.com/kinglevel/TimecodeTokenDelMA3

]]--


require("gma3_helpers")




local function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[deepcopy(orig_key)] = deepcopy(orig_value)
      end
      setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end




local function tablesDiffer(table1, table2)
  -- Check if both tables are actually tables
  if type(table1) ~= "table" or type(table2) ~= "table" then
      return false
  end

  -- Function to compare two values
  local function compareValues(v1, v2)
      if type(v1) == "table" and type(v2) == "table" then
          return tablesDiffer(v1, v2)
      else
          return v1 ~= v2
      end
  end

  -- Check all keys and values in table1 against table2
  for key, value in pairs(table1) do
      if compareValues(value, table2[key]) then
          return true
      end
  end

  -- Check all keys and values in table2 against table1
  for key, value in pairs(table2) do
      if compareValues(value, table1[key]) then
          return true
      end
  end

  return false
end






local function deleteTableObjEntry(tokenstable)

  for i = 1, #tokenstable do
    tokenstable[i]:Parent():Delete(tokenstable[i].index)
  end

end









local function searchToken()

  local dp = 1
  local tc = 2



  local x = Root()["ShowData"]["Datapools"][dp]["Timecodes"][2]

  local tokenstable = {}

  --the sheebaaang
  for i = 1, #x do

    for t = 1, #x[i] do

      local track = x[i][t]

      --only work with tracks
      if track:GetClass() == "Track" then

        --in time ranges
        for timerange = 1, #track do

          -- and subtracks
          local cmdsubtrack = track[timerange][1]

          --get all events
          for event = 1, #cmdsubtrack do

            if cmdsubtrack[event].name == "<Token>" then
              table.insert(tokenstable, cmdsubtrack[event])
              --gma3_helpers:dump(cmdsubtrack[event])

            end

          end

        end

      end

    end
  end


return tokenstable


end






local function loop()


  local previous = searchToken()


  while true do
    local current = searchToken()
    --check if stuff has changed
    if tablesDiffer(current, previous) then
      Printf("stuff happend")
      deleteTableObjEntry(current)
    end
    --make a real copy of the table to compare
    previous = deepcopy(current)
    --stability
    --sleep(0.1)
  end



end









local function Main(displayHandle)

  --init
  if not MidiDel then
    MidiDel = nil
  end

  -- init
  if MidiDel == nil then
    MidiDel = 0
  end



  -- startup
  if MidiDel == 0 then
    Printf(name.. ": Turning on")
    MidiDel = 1
    loop()
  end

  -- turn off
  if MidiDel == 1 then
    Printf(name.. ": Turning off")
    MidiDel = 0
    Cmd("off plugin '"..name.."'")
  end


end







return Main
