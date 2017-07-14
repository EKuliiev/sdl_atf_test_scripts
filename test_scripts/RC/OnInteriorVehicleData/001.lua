---------------------------------------------------------------------------------------------------
-- RPC: OnInteriorVehicleData
-- Script: 001
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local commonRC = require('test_scripts/RC/commonRC')
local runner = require('user_modules/script_runner')
local commonTestCases = require('user_modules/shared_testcases/commonTestCases')

--[[ Local Valiables ]]
local climateControlData = {
    fanSpeed = 50,
    currentTemp = 86,
    desiredTemp = 75,
    temperatureUnit = "FAHRENHEIT",
    acEnable = true,
    circulateAirEnable = true,
    autoModeEnable = true,
    defrostZone = "FRONT",
    dualModeEnable = true
}

local radioControlData = {
    frequencyInteger = 1,
    frequencyFraction = 2,
    band = "AM",
    rdsData = {
        PS = "ps",
        RT = "rt",
        CT = "123456789012345678901234",
        PI = "pi",
        PTY = 2,
        TP = false,
        TA = true,
        REG = "US"
      },
    availableHDs = 1,
    hdChannel = 1,
    signalStrength = 5,
    signalChangeThreshold = 20,
    radioEnable = true,
    state = "ACQUIRING"
}

--[[ Local Functions ]]
local function getModuleData(moduleType, moduleControlData)
	if moduleType == "CLIMATE" then
		return {moduleType = moduleType, climateControlData = moduleControlData or commonRC.getClimateControlData()}
	end
	return {moduleType = moduleType, radioControlData = moduleControlData or commonRC.getRadioControlData()}
end

local function subscriptionToModule(pModuleType, pSubscribe, self)
	local cid = self.mobileSession:SendRPC("GetInteriorVehicleData", {
		moduleDescription =	{
			moduleType = pModuleType
		},
		subscribe = pSubscribe
	})

	EXPECT_HMICALL("RC.GetInteriorVehicleData", {
		appID = self.applications["Test Application"],
		moduleDescription =	{
			moduleType = pModuleType
		},
		subscribe = pSubscribe
	})
  :Do(function(_, data)
			self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
				moduleData = getModuleData(pModuleType),
				isSubscribed = pSubscribe
			})
	end)

	EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS",
 				moduleData = getModuleData(pModuleType),
				isSubscribed = pSubscribe
			})
end

local function stepSubscribed(pModuleType, pModuleControlData, self)
 	self.hmiConnection:SendNotification("RC.OnInteriorVehicleData", {
			moduleData = getModuleData(pModuleType, pModuleControlData)
	  })

  EXPECT_NOTIFICATION("OnInteriorVehicleData", {
  		moduleData = getModuleData(pModuleType, pModuleControlData)
  	})
end

local function stepUnsubscribed(pModuleType, pModuleControlData, self)
 	self.hmiConnection:SendNotification("RC.OnInteriorVehicleData", {
			moduleData = getModuleData(pModuleType, pModuleControlData)
	  })

  EXPECT_NOTIFICATION("OnInteriorVehicleData", {}):Times(0)
  commonTestCases:DelayedExp(commonRC.timeout)
end

--[[ Scenario ]]
runner.Title("Preconditions")
runner.Step("Clean environment", commonRC.preconditions)
runner.Step("Start SDL, HMI, connect Mobile, start Session", commonRC.start)
runner.Step("RAI, PTU", commonRC.rai_ptu)
runner.Title("Test")
runner.Step("Subscribe app to CLIMATE", subscriptionToModule, {"CLIMATE", true})
runner.Step("Send notification OnInteriorVehicleData_CLIMATE. App subscribed", stepSubscribed, {"CLIMATE", climateControlData})
runner.Step("Subscribe app to RADIO", subscriptionToModule, {"RADIO", true})
runner.Step("Send notification OnInteriorVehicleData_RADIO. App subscribed", stepSubscribed, {"RADIO", radioControlData})
runner.Step("Unsubscribe app to CLIMATE", subscriptionToModule, {"CLIMATE", false})
runner.Step("Send notification OnInteriorVehicleData_CLIMATE. App unsubscribed", stepUnsubscribed, {"CLIMATE", climateControlData})
runner.Step("Unsubscribe app to RADIO", subscriptionToModule, {"RADIO", false})
runner.Step("Send notification OnInteriorVehicleData_RADIO. App unsubscribed", stepUnsubscribed, {"RADIO", radioControlData})
runner.Title("Postconditions")
runner.Step("Stop SDL", commonRC.postconditions)
