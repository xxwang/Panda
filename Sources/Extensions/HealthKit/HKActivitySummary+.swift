
import HealthKit

public extension HKActivitySummary {
    var pd_isCompleteStandHoursGoal: Bool {
        appleStandHoursGoal.compare(appleStandHours) != .orderedDescending
    }

    var pd_isCompleteExerciseTimeGoal: Bool {
        appleExerciseTimeGoal.compare(appleExerciseTime) != .orderedDescending
    }

    var pd_isCompleteActiveEnergyBurnedGoal: Bool {
        activeEnergyBurnedGoal.compare(activeEnergyBurned) != .orderedDescending
    }
}
