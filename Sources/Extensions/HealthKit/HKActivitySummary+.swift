
import HealthKit

public extension HKActivitySummary {
    var sk_isCompleteStandHoursGoal: Bool {
        appleStandHoursGoal.compare(appleStandHours) != .orderedDescending
    }

    var sk_isCompleteExerciseTimeGoal: Bool {
        appleExerciseTimeGoal.compare(appleExerciseTime) != .orderedDescending
    }

    var sk_isCompleteActiveEnergyBurnedGoal: Bool {
        activeEnergyBurnedGoal.compare(activeEnergyBurned) != .orderedDescending
    }
}
