local pluginName     = select(1,...);
local componentName  = select(2,...);
local signalTable    = select(3,...);
local my_handle      = select(4,...);
----------------------------------------------------------------------------------------------------------------


local PlugTitle = "Timecode Token Deleter"

local messageDescription =  "USE WITH CAUTION, TAKE BACKUPS.\n\n"..
                            "This tool will search and delete all objects with given name in your timecode.\n\n"


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





-- Confirm
local function confirmbox(displayHandle, message)
  if Confirm(PlugTitle, message) then
    return true
  else
    return false
  end
end




---settings
local function settingsWindow(displayHandle)


    --set window settings
    local options = {
        title=PlugTitle,
        backColor="Global.Focus",
        icon="invert",

        message=messageDescription,

        display= nil,

        commands={
            {value=0, name="Abort"},
            {value=1, name="Run"}
        },

        inputs={
            {name="Timecode", value=""},
            {name="Remove", value="<Token>"}
        }
    }




    -- spawn window
    local userInput = MessageBox(options)
    local userConfirm = userInput.result


    -- Abort
    if userConfirm == 0 then
        Printf("Aborted by user")
        return false
    end



    -- Run
    if userConfirm == 1 then

      --get all variables from the user
      local timecode = userInput.inputs["Timecode"]
      local remove = userInput.inputs["Remove"]

      local userConfirmRun = confirmbox(displayHandle,
      "Are you sure you want to delete ALL:\n" ..
      "Objects: " .. remove .. "\n" ..
      "From\n" ..
      "timecode: " .. timecode .. "\n")

      if userConfirmRun == true then
        Printf("User confirmed!")
        return timecode, remove
      elseif userConfirmRun == false then
        Printf("User aborted")
        return false
      end


    end

end






local function SearchObjects(obj, string)
  --Modified GMA3helper:tree
  local objects = {}

  local function printDirectory(dir, prefix, depth)
      local i = 1;
      while dir[i] do
          local content = dir[i]
          --Get all the intresting event classes
          if content.name == string then
            table.insert(objects, content)
          end
          
          printDirectory(content,prefix..'|   ', depth+1) -- use recursion
          i = i + 1;
      end
  end

  printDirectory(obj,'',1)

  return objects
end






local function DeleteObjects(table)
  local tablesize = #table
    for i = 1, tablesize do
        table[i]:Parent():Delete(table[i].index)
    end
end





local function Main(displayHandle)

  --Get settings and confirmation from user
  local timecode, remove = settingsWindow(displayHandle)

  --if all set, go
  if timecode ~= "" then
      local p = DataPool().Timecodes[tonumber(timecode)]
      local s = SearchObjects(p, remove)
      local k = DeleteObjects(s)
  end

end





return Main
