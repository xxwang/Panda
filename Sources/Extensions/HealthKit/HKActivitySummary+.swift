
import HealthKit

public extension HKActivitySummary {
    var xx_isCompleteStandHoursGoal: Bool {
        appleStandHoursGoal.compare(appleStandHours) != .orderedDescending
    }

    var xx_isCompleteExerciseTimeGoal: Bool {
        appleExerciseTimeGoal.compare(appleExerciseTime) != .orderedDescending
    }

    var xx_isCompleteActiveEnergyBurnedGoal: Bool {
        activeEnergyBurnedGoal.compare(activeEnergyBurned) != .orderedDescending
    }
}
