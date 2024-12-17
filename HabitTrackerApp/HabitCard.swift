import SwiftUI

struct HabitCard: View {
    let habit: Habit

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Set the habit name's font color to white
                Text(habit.name)
                    .font(.system(size: 16, design: .default)) // Explicit font setting
                    .foregroundColor(.white) // Set the font color to white
                    .lineLimit(1) // Ensure text does not wrap
                    .truncationMode(.tail) // Truncate if the text is too long for the space

                // Set the streak's font color to white
                Text("Streak: \(habit.streak)")
                    .font(.system(size: 16, weight: .regular, design: .default)) // Set font for subheadline
                    .foregroundColor(.white) // Set the streak font color to white
                    .lineLimit(1) // Ensure no wrapping
                    .truncationMode(.tail) // Truncate if necessary
            }
            Spacer()
        }
        .padding()
        .background(
            // Apply Linear Gradient with reduced opacity
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.green.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(12) // Rounded corners
        )
        .shadow(radius: 5) // Add shadow for depth
        .padding(.horizontal) // Optional: Add horizontal padding for spacing
    }
}
