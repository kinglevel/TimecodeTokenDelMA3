local pluginName     = select(1,...);
local componentName  = select(2,...);
local signalTable    = select(3,...);
local my_handle      = select(4,...);
----------------------------------------------------------------------------------------------------------------

-- Almost never tested

-- Github: https://github.com/kinglevel
-- Please commit or post updates for the community.


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

]]--





-- Confirm
local function confirmbox(displayHandle, message)
  if Confirm(PlugTitle, message) then
    return true
  else
    return false
  end
end





--Magic
local function delTCstuff (vartg, vartn)
    Printf("##### Timecode MIDIRemote delete #####")

    --int
    local tg = vartg
    --str
    local tn = vartn

    local s=DataPool().Timecodes[tn][tg]
    local d=#s

    for i = 1, d do

      if string.match(s[i].name, "MIDIRemote") then
        Printf((i-1) .. " " .. s[i].name)
        s:Delete(i)
      end

    end

end




---settings
local function settingsWindow(displayHandle)

    --retrieve variables
    local userVar = UserVars()
    local resultTN = GetVar(userVar, "tcDelName")
    local resultTG = GetVar(userVar, "tcDelTrackGroup")


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
            {name="TC Object name", value=resultTN},
            {name="TC Object TrackGroup", value=resultTG}
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
      Printf("Confirming...")


      local userConfirmRun = confirmbox(displayHandle, "Are you sure?")

      if userConfirmRun == true then
        Printf("User confirmed!")

          local setSuccess = SetVar(userVar, "tcDelName", userInput.inputs["TC Object name"])
          local setSuccess = SetVar(userVar, "tcDelTrackGroup", userInput.inputs["TC Object TrackGroup"])

          local resultVarTN = GetVar(userVar, "tcDelName")
          local resultVarTG = tonumber(GetVar(userVar, "tcDelTrackGroup"))

          --magic
          delTCstuff(resultVarTG, resultVarTN)

      elseif userConfirmRun == false then
        Printf("User aborted")
      end


    end






end








local function Main ()


  settingsWindow()


end





return Main
