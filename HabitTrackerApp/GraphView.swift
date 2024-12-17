import SwiftUI

struct GraphView: View {
    @ObservedObject var viewModel: HabitViewModel

    // Fetch habit data
    func getHabitData() -> [(String, Int)] {
        return viewModel.habits.map { habitEntity in
            let name = habitEntity.name ?? "Unknown Habit"
            let streak = Int(habitEntity.streak)
            return (name, streak)
        }
    }

    // Find the max streak
    func getMaxStreak() -> Int {
        let streaks = getHabitData().map { $0.1 }
        return streaks.max() ?? 1
    }

    // Generate Y-axis ticks
    func generateYAxisTicks() -> [Int] {
        let maxStreak = getMaxStreak()
        guard maxStreak > 0 else { return [0] } // Ensure at least one tick
        let step = max(maxStreak / 5, 1)
        return stride(from: 0, through: maxStreak, by: step).map { $0 }
    }

    var body: some View {
        VStack {
            // Title: "Habit Streaks Over Time"
            Text("Habit Streaks Over Time")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 30) // Added some space from the top of the screen

            // The graph area with gradient background
            ZStack {
                // Gradient Background for the graph section
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.green.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .cornerRadius(15)
                    .padding(.top, 10) // Adding a bit of space from the title

                VStack {
                    if viewModel.habits.isEmpty {
                        // No habits available message
                        Text("No habits available. Please add habits to view the graph.")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.8)) // Background with shape
                                    .shadow(radius: 5) // Shadow for better visibility
                            )
                            .padding(.horizontal) // Add horizontal padding for spacing
                    } else {
                        HStack(alignment: .top) {
                            // Y-Axis Section
                            VStack {
                                ForEach(generateYAxisTicks().reversed(), id: \.self) { tick in
                                    Text("\(tick)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(
                                            height: generateYAxisTicks().count > 1
                                                ? 220 / CGFloat(generateYAxisTicks().count - 1)
                                                : 200
                                        )
                                }
                            }
                            .padding(.trailing, 5)

                            // Bars Section with ScrollView
                            ScrollView(.horizontal) {
                                VStack {
                                    HStack(alignment: .bottom, spacing: 10) {
                                        ForEach(getHabitData(), id: \.0) { habit in
                                            VStack {
                                                // Bar for each habit
                                                HabitBarChartView(streakCount: habit.1, maxStreak: getMaxStreak())
                                                    .frame(width: 40) // Keep width fixed for consistency

                                                // Display habit names with wrapping for longer names
                                                Text(self.breakHabitName(habit.0))
                                                    .font(.caption)
                                                    .lineLimit(2) // Allow text to break into two lines
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: 50) // Restrict width to avoid overflow
                                                    .fixedSize(horizontal: false, vertical: true) // Ensure wrapping works
                                            }
                                            .frame(height: 320, alignment: .bottom) // Increased height for bars and labels
                                        }
                                    }
                                }
                                .padding(.leading, 10) // Aligns bars with Y-axis
                            }
                            .frame(height: 350) // Increased height of the graph area
                        }
                        .padding(.horizontal, 10) // Padding for the whole graph area
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9)) // Fill the background with white color
                                .shadow(radius: 10) // Add a shadow for better visibility
                        )
                    }
                }
                .padding(.horizontal, 10)  // Set horizontal padding
            }
        }
        .onAppear {
            viewModel.fetchHabits()
        }
    }

    // Helper function to split habit names based on spaces (if they are two or more words)
    func breakHabitName(_ name: String) -> String {
        let words = name.split(separator: " ")
        if words.count > 1 {
            // If the name has more than one word, join them into two lines
            return words.prefix(1).joined() + "\n" + words.suffix(from: 1).joined(separator: " ")
        } else {
            // If the name is a single word, return it as is
            return name
        }
    }
}

struct HabitBarChartView: View {
    var streakCount: Int
    var maxStreak: Int

    // Predefined set of colors
    let colors: [Color] = [
        Color.blue.opacity(0.6),  // Light Blue
        Color.green.opacity(0.6), // Green
        Color.red.opacity(0.6),   // Red
        Color.pink.opacity(0.6),  // Pink
        Color.gray.opacity(0.6),  // Gray
        Color.orange.opacity(0.6),// Orange
        Color.yellow.opacity(0.6) // Yellow
    ]
    
    // Function to pick a random color from the predefined set
    func randomColor() -> Color {
        return colors.randomElement() ?? Color.blue // Fallback to blue if random fails
    }

    @State private var animatedHeight: CGFloat = 0

    var body: some View {
        // Set bar height dynamically based on streak count and max streak
        let barHeight = streakCount == 0 ? 0 : CGFloat(streakCount) / CGFloat(maxStreak) * 200

        // Animate the bar height when the view appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 1.0)) {
                self.animatedHeight = barHeight
            }
        }

        return Rectangle()
            .fill(randomColor()) // Apply random color from predefined set
            .frame(height: max(0, animatedHeight)) // Use the animated height
            .cornerRadius(5)
            .shadow(radius: 5) // Add shadow for better visibility
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(viewModel: HabitViewModel())
    }
}
