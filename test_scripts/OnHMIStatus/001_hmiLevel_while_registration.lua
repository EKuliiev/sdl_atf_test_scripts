---------------------------------------------------------------------------------------------------
-- Issue: https://github.ford.com/SYNC/sdl_core/issues/98
---------------------------------------------------------------------------------------------------
-- Description:
-- In case:
-- 1) Mobile app is in some state
-- 2) Mobile app is moving to another state by one of the events:
--   App activation, App deactivation, Deactivation of HMI, User exit
-- SDL must:
-- 1) Send (or not send) OnHMIStatus notification with appropriate value of 'hmiLevel' parameter
-- Particular behavior and value depends on initial state and event, and described in 'testCases' table below
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local common = require('test_scripts/OnHMIStatus/common')
local runner = require('user_modules/script_runner')

--[[ Test Configuration ]]
runner.testSettings.isSelfIncluded = false
config.checkAllValidations = true

--[[ Event Functions ]]
local action = {
  activateApp = {
    name = "Activation",
    func = function()
      local requestId = common.getHMIConnection():SendRequest("SDL.ActivateApp", {
        appID = common.getHMIAppId() })
      common.getHMIConnection():ExpectResponse(requestId)
    end
  },
 deactivateApp = {
    name = "De-activation",
    func = function()
      common.getHMIConnection():SendNotification("BasicCommunication.OnAppDeactivated", {
        appID = common.getHMIAppId() })
    end
  },
  deactivateHMI = {
    name = "HMI De-activation",
    func = function()
      common.getHMIConnection():SendNotification("BasicCommunication.OnEventChanged", {
        eventName = "DEACTIVATE_HMI",
        isActive = true })
    end
  },
  activateHMI = {
    name = "HMI Activation",
    func = function()
      common.getHMIConnection():SendNotification("BasicCommunication.OnEventChanged", {
        eventName = "DEACTIVATE_HMI",
        isActive = false })
    end
  },
  exitApp = {
    name = "User Exit",
    func = function()
      common.getHMIConnection():SendNotification("BasicCommunication.OnExitApplication", {
        appID = common.getHMIAppId(),
        reason = "USER_EXIT" })
    end
  }
}

--[[ Local Variables ]]
local testCases = {
  [001] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [002] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [003] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [004] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [005] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [006] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [007] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [008] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [009] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [010] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [011] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [012] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [013] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [014] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [015] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [016] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [017] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [018] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [019] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [020] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [021] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [022] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [023] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [024] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [025] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [026] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }},
  [027] = { t = "NAVIGATION", m = true,  s = {
    [1] = { e = action.activateApp,   l = "FULL",       a = "AUDIBLE" },
    [2] = { e = action.deactivateApp, l = "LIMITED",    a = "AUDIBLE" }
  }}
}

--[[ Local Functions ]]
local function doAction(pTC, pSS)
  pSS.e.func()
  common.getMobileSession():ExpectNotification("OnHMIStatus")
  :ValidIf(function(_, data)
      return common.checkAudioSS(pTC, pSS.e.name, pSS.a, data.payload.audioStreamingState)
    end)
  :ValidIf(function(_, data)
      return common.checkVideoSS(pTC, pSS.e.name, pSS.v, data.payload.videoStreamingState)
    end)
  :ValidIf(function(_, data)
      return common.checkHMILevel(pTC, pSS.e.name, pSS.l, data.payload.hmiLevel)
    end)
end

--[[ Scenario ]]
for n, tc in common.spairs(testCases) do
  runner.Title("TC[" .. string.format("%03d", n) .. "]: "
    .. "[hmiType:" .. tc.t .. ", isMedia:" .. tostring(tc.m) .. "]")
  runner.Step("Clean environment", common.preconditions)
  runner.Step("Start SDL, HMI, connect Mobile, start Session", common.start)
  runner.Step("Set App Config", common.setAppConfig, { 1, tc.t, tc.m })
  runner.Step("Register App", common.registerApp)
  for i = 1, #tc.s do
    runner.Step("Action:" .. tc.s[i].e.name .. ",hmiLevel:" .. tc.s[i].l, doAction, { n, tc.s[i] })
  end
  runner.Step("Clean sessions", common.cleanSessions)
  runner.Step("Stop SDL", common.postconditions)
end
runner.Step("Print failed TCs", common.printFailedTCs)
