//
//  FitnessMachineService.swift
//  Created by Michael Simms on 2/4/23.
//

import Foundation

/// @brief Key names used with the JSON parser.
let KEY_NAME_FITNESS_MACHINE_TYPE = "Fitness Machine Type"

let TREADMILL_SUPPORTED: UInt16 = 0x01
let CROSS_TRAINER_SUPPORTED: UInt16 = 0x02
let STEP_CLIMBER_SUPPORTED: UInt16 = 0x04
let STAIR_CLIMBER_SUPPORTED: UInt16 = 0x08
let ROWER_SUPPORTED: UInt16 = 0x10
let INDOOR_BIKE_SUPPORTED: UInt16 = 0x20

let AVERAGE_SPEED_SUPPORTED: UInt32 = 0x0001
let CADENCE_SUPPORTED: UInt32 = 0x0002
let TOTAL_DISTANCE_SUPPORTED: UInt32 = 0x0004
let INCLINATION_SUPPORTED: UInt32 = 0x0008
let ELEVATION_GAIN_SUPPORTED: UInt32 = 0x0010
let PACE_SUPPORTED: UInt32 = 0x0020
let STEP_COUNT_SUPPORTED: UInt32 = 0x0040
let RESISTANCE_LEVEL_SUPPORTED: UInt32 = 0x0080
let EXPENDED_ENERGY_SUPPORTED: UInt32 = 0x0100
let HEART_RATE_MEASUREMENT_SUPPORTED: UInt32 = 0x0200
let METABOLIC_EQUIVALENT_SUPPORTED: UInt32 = 0x0400
let ELAPSED_TIME_SUPPORTED: UInt32 = 0x0800
let REMAINING_TIME_SUPPORTED: UInt32 = 0x1000
let POWER_MEASUREMENT_SUPPORTED: UInt32 = 0x2000
let FORCE_ON_BELT_AND_POWER_OUTPUT_SUPPORTED: UInt32 = 0x4000
let USER_DATA_RETENTION_SUPPORTED: UInt16 = 0x8000

let SPEED_TARGET_SETTING_SUPPORTED: UInt32 = 0x0001
let INCLINATION_TARGET_SETTING_SUPPORTED: UInt32 = 0x0002
let RESISTANCE_TARGET_SETTING_SUPPORTED: UInt32 = 0x0004
let POWER_TARGET_SETTING_SUPPORTED: UInt32 = 0x0008
let HEART_RATE_TARGET_SETTING_SUPPORTED: UInt32 = 0x0010
let TARGETED_EXPENDED_ENERGY_CONFIGURATION_SUPPORTED: UInt32 = 0x0020
let TARGETED_STEP_NUMBER_CONFIGURATION_SUPPORTED: UInt32 = 0x0040
let TARGETED_STRIDE_NUMBER_CONFIGURATION_SUPPORTED: UInt32 = 0x0080
let TARGETED_DISTANCE_CONFIGURATION_SUPPORTED: UInt32 = 0x0080
let TARGETED_TRAINING_TIME_CONFIGURATION_SUPPORTED: UInt32 = 0x0100
let TARGETED_TIME_IN_TWO_HEART_RATE_ZONES_CONFIGURATION_SUPPORTED: UInt32 = 0x0200
let TARGETED_TIME_IN_THREE_HEART_RATE_ZONES_CONFIGURATION_SUPPORTED: UInt32 = 0x0400
let TARGETED_TIME_IN_FIVE_HEART_RATE_ZONES_CONFIGURATION_SUPPORTED: UInt32 = 0x0800
let INDOOR_BIKE_SIMULATION_PARAMETERS_SUPPORTED: UInt32 = 0x1000
let WHEEL_CIRCUMFERENCE_CONFIGURATION_SUPPORTED: UInt32 = 0x2000
let SPIN_DOWN_CONTROL_SUPPORTED: UInt32 = 0x4000
let TARGETED_CADENCE_CONFIGURATION_SUPPORTED: UInt32 = 0x8000

struct ServiceDataADType {
	var serviceDataADType: UInt8 = 0
	var fitnessMachineService: UInt16 = 0
	var flags: UInt8 = 0
	var fitnessMachineType: UInt16 = 0
}

enum FitnessMachineException: Error {
	case runtimeError(String)
}

func decodeFitnessMachineService(data: Data) throws -> Dictionary<String, UInt32> {
	var result: Dictionary<String, UInt32> = [:]

	if data.count < MemoryLayout<ServiceDataADType>.size {
		throw FitnessMachineException.runtimeError("Not enough data")
	}

	var serviceDataAD: ServiceDataADType = ServiceDataADType()
	serviceDataAD.serviceDataADType = data[0]
	serviceDataAD.fitnessMachineService = CFSwapInt16LittleToHost(((UInt16)(data[1]) << 8) | (UInt16)(data[2]))
	serviceDataAD.flags = data[3]
	serviceDataAD.fitnessMachineType = CFSwapInt16LittleToHost(((UInt16)(data[4]) << 8) | (UInt16)(data[5]))

	result[KEY_NAME_FITNESS_MACHINE_TYPE] = UInt32(serviceDataAD.fitnessMachineType)

	return result
}
