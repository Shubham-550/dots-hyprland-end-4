-- autosave.lua
--
-- https://gist.github.com/TheDrHax/fa2dba9023aace168de029f51799948d
--
-- Periodically saves "watch later" data during playback, rather than only saving on quit.
-- This lets you easily recover your position in the case of an ungraceful shutdown of mpv (crash, power failure, etc.).
--
-- You can configure the save period by creating a "script-opts" directory inside your mpv configuration directory.
-- Inside the "script-opts" directory, create a file named "autosave.conf".
-- The save period can be set like so:
--
-- save_period=60
--
-- This will set the save period to once every 60 seconds of playback, time while paused is not counted towards the save period timer.
-- The default save period is 30 seconds.

local options = require 'mp.options'

local o = {
  save_period = 30
}

options.read_options(o)

local mp = require 'mp'

local function save()
  mp.command("write-watch-later-config")
  
  if doStop then
    save_period_timer:stop()
    doStop = false
  end
end

local save_period_timer
local doStop = false

local function init()
  if not mp.get_property_bool("seekable", true) then
    return
  end

  save_period_timer = mp.add_periodic_timer(o.save_period, save)

  local function pause(name, paused)
    if paused then
      doStop = true
    else
      save_period_timer:resume()
    end
  end

  mp.observe_property("pause", "bool", pause)
end

mp.register_event("file-loaded", init)
