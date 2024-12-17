import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: HabitViewModel
    
    // State variables for animating counts (initialized to 0)
    @State private var animatedTotalHabits: Double = 0
    @State private var animatedTotalStreaks: Double = 0
    @State private var animatedMaxStreak: Double = 0

    // The duration (in seconds) for the count-up animation
    let animationDuration: TimeInterval = 2.0
    // Adjust this to control the speed of the increment
    let incrementSpeed: Double = 50.0 // Lower value increases speed

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Title Section with Big Bold Font
                Text("Habit Stats")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)
                    .shadow(radius: 5) // Light shadow for depth
                    .padding(.top, 40)
                
                // Stats Cards
                VStack(spacing: 20) {
                    // Total Habits Section
                    StatCardView(title: "Total Habits", value: "\(Int(animatedTotalHabits))", color: Color.blue.opacity(0.6))

                    // Total Streaks Section
                    StatCardView(title: "Total Streaks", value: "\(Int(animatedTotalStreaks)) days", color: Color.green.opacity(0.9))

                    // Max Streak Section
                    if let maxStreakHabit = viewModel.habits.max(by: { $0.streak < $1.streak }) {
                        StatCardView(title: "Max Streak", value: "\(Int(animatedMaxStreak)) days", color: Color.blue.opacity(0.6))
                    }
                }
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.green.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
                        .shadow(radius: 10)
                )
                .padding(.top, 20)

                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.green.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitleDisplayMode(.inline)  // Sets the navigation title to "inline"
        }
        .onAppear {
            viewModel.fetchHabits() // Fetch the habits when the StatsView appears
            
            // Calculate totals
            let totalHabits = viewModel.habits.count
            let totalStreaks = viewModel.habits.reduce(0) { $0 + Int($1.streak) }
            let maxStreakHabit = viewModel.habits.max(by: { $0.streak < $1.streak })

            // Animate the values using a timer, pass the Binding directly
            animateCount(to: Double(totalHabits), for: $animatedTotalHabits)
            animateCount(to: Double(totalStreaks), for: $animatedTotalStreaks)
            
            if let maxStreak = maxStreakHabit?.streak {
                animateCount(to: Double(maxStreak), for: $animatedMaxStreak)
            }
        }
    }

    // Function to animate count values
    func animateCount(to targetValue: Double, for stateProperty: Binding<Double>) {
        var currentValue = 0.0
        
        // Start a timer to increment the value over time
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            withAnimation {
                // Increase the rate of increment by adjusting the denominator value
                currentValue += targetValue / (animationDuration * incrementSpeed) // Speed up the increment
                if currentValue >= targetValue {
                    currentValue = targetValue
                    timer.invalidate() // Stop the timer when the target value is reached
                }
                // Update the state property using the binding
                stateProperty.wrappedValue = currentValue
            }
        }
    }
}

struct StatCardView: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .transition(.opacity) // Optional: Fade in the text for better animation effect
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(color)
        )
        .shadow(radius: 5)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(viewModel: HabitViewModel())
    }
}
