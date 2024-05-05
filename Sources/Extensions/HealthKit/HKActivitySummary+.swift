//
//  HKActivitySummary+.swift
//
//
//  Created by xxwang on 2023/5/26.
//

import HealthKit

// MARK: - 判断
public extension HKActivitySummary {
    /// 是否完成设定的站立目标(小时数)
    var isCompleteStandHoursGoal: Bool {
        appleStandHoursGoal.compare(appleStandHours) != .orderedDescending
    }

    /// 检查是否达到设置的锻炼时间
    var isCompleteExerciseTimeGoal: Bool {
        appleExerciseTimeGoal.compare(appleExerciseTime) != .orderedDescending
    }

    /// 检查是否达到设置的活动能量
    var isCompleteActiveEnergyBurnedGoal: Bool {
        activeEnergyBurnedGoal.compare(activeEnergyBurned) != .orderedDescending
    }
}
