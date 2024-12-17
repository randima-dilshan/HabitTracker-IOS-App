//
//  Habit.swift
//  HabitTrackerApp
//
//  Created by IM Student on 2024-11-20.
//

import Foundation

struct Habit: Identifiable {
    var id = UUID() // A unique identifier for each habit
    var name: String // The name of the habit
    var streak: Int // Tracks how many days in a row the habit was completed
    var nextGoal: Int // The next milestone goal for the habit (e.g., next 10-day milestone)

    init(from habitEntity: HabitEntity) {
        self.id = habitEntity.id ?? UUID()
        self.name = habitEntity.name ?? ""
        self.streak = Int(habitEntity.streak)
        
        // Set the next goal based on the streak (e.g., next multiple of 10)
        self.nextGoal = (self.streak / 10 + 1) * 10
    }
}
