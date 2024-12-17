import CoreData
import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var habits: [HabitEntity] = [] // Published array to automatically update the view
    private let viewContext = PersistenceController.shared.container.viewContext
    
    // Fetch habits from Core Data
    func fetchHabits() {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        
        do {
            habits = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch habits: \(error)")
        }
    }

    // Add a new habit to Core Data
    func addHabit(name: String) {
        let newHabit = HabitEntity(context: viewContext)
        newHabit.id = UUID()
        newHabit.name = name
        newHabit.streak = 0
        
        saveContext()
        fetchHabits() // Refresh the habits after adding
    }

    // Delete a habit from Core Data
    func deleteHabit(_ habit: HabitEntity) {
        viewContext.delete(habit)
        saveContext()
        fetchHabits() // Refresh habits after deletion
    }

    // Increment streak for a habit
    func incrementStreak(for habit: HabitEntity) {
        habit.streak += 1
        saveContext()
        fetchHabits() // Refresh after increment
    }

    // Reset streak for a habit
    func resetStreak(for habit: HabitEntity) {
        habit.streak = 0
        saveContext()
        fetchHabits() // Refresh after reset
    }

    // Save the context (Core Data)
    private func saveContext() {
        PersistenceController.shared.saveContext()
    }

    // Update habit's name
    func updateHabit(_ habit: HabitEntity, newName: String) {
        habit.name = newName
        saveContext() // Save the changes in Core Data
        fetchHabits() // Reload the habits after updating
    }
}
