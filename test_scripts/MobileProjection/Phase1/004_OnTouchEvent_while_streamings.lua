---------------------------------------------------------------------------------------------------
-- User story: TBD
-- Use case: TBD
--
-- Requirement summary:
-- TBD
--
-- Description:
-- In case:
-- 1) Application is registered with PROJECTION appHMIType
-- 2) and starts video and audio streaming
-- 3) HMI sends OnTouchEvent
-- SDL must:
-- 1) successful transfer notifications to mobile application
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local common = require('test_scripts/MobileProjection/Phase1/common')
local runner = require('user_modules/script_runner')

--[[ Test Configuration ]]
runner.testSettings.isSelfIncluded = false

--[[ Local Variables ]]
local appHMIType = "PROJECTION"
local OnTouchEventType = {
  "BEGIN",
  "MOVE",
  "END",
  "CANCEL",
}
local NotifParams = {
  type = "BEGIN",
  event = { {c = {{x = 1, y = 1}}, id = 1, ts = {1} } }
}

--[[ General configuration parameters ]]
config.application1.registerAppInterfaceParams.appHMIType = { appHMIType }

--[[ Local Functions ]]
local function ptUpdate(pTbl)
  pTbl.policy_table.app_policies[common.getConfigAppParams().appID].AppHMIType = { appHMIType }
  pTbl.policy_table.app_policies[common.getConfigAppParams().appID].groups = { "Base-4", "OnTouchEventOnlyGroup" }
end

local function OnTouchEvent(parameters)
  common.getHMIConnection():SendNotification("UI.OnTouchEvent", parameters)
  common.getMobileSession():ExpectNotification("OnTouchEvent", parameters)
end

--[[ Scenario ]]
runner.Title("Preconditions")
runner.Step("Clean environment", common.preconditions)
runner.Step("Start SDL, HMI, connect Mobile, start Session", common.start)
runner.Step("Register App", common.registerApp)
runner.Step("PolicyTableUpdate with HMI types", common.policyTableUpdate, { ptUpdate })
runner.Step("Activate App", common.activateApp)
runner.Step("Start video service", common.startService, { 11 })
runner.Step("Start audio service", common.startService, { 10 })
runner.Step("Start video streaming", common.StartStreaming, { 11, "files/SampleVideo_5mb.mp4" })
runner.Step("Start audio streaming", common.StartStreaming, { 10, "files/MP3_4555kb.mp3" })

runner.Title("Test")
for key, value in pairs(OnTouchEventType) do
  local parameters = common.cloneTable(NotifParams)
  parameters.type = value
  parameters.event[1].c[1].x = parameters.event[1].c[1].x + key
  parameters.event[1].c[1].y = parameters.event[1].c[1].y + key
  parameters.event[1].ts[1] = parameters.event[1].ts[1] + key
  runner.Step("OnTouchEvent with type " .. value, OnTouchEvent, { parameters })
end

runner.Title("Postconditions")
runner.Step("Stop video streaming", common.StopStreaming, { 11, "files/SampleVideo_5mb.mp4" })
runner.Step("Stop audio streaming", common.StopStreaming, { 10, "files/MP3_4555kb.mp3" })
runner.Step("Stop SDL", common.postconditions)
