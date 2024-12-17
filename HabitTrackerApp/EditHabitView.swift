import SwiftUI

struct EditHabitView: View {
    @Environment(\.presentationMode) var presentationMode // To close the screen
    @ObservedObject var viewModel: HabitViewModel // ViewModel to update the habit
    var habit: HabitEntity // The habit to be edited

    @State private var habitName: String // State to hold the edited habit name

    init(viewModel: HabitViewModel, habit: HabitEntity) {
        self.viewModel = viewModel
        self.habit = habit
        _habitName = State(initialValue: habit.name ?? "") // Initialize the habit name with the existing value
    }

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.green.opacity(0.4)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea() // Cover the entire screen

            VStack(spacing: 20) {
                // Optional Illustration/Icon
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                Text("Edit Habit")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                // Form-Like Card with Rounded Corners
                VStack(spacing: 16) {
                    // TextField with Styling
                    TextField("Edit Habit Name", text: $habitName)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    // Save Changes Button
                    Button(action: {
                        if !habitName.isEmpty {
                            viewModel.updateHabit(habit, newName: habitName)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Save Changes")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .shadow(radius: 5)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal, 20)

                Spacer() // Push content to the top
            }
        }
    }
}

struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock HabitEntity for preview
        EditHabitView(viewModel: HabitViewModel(), habit: HabitEntity())
    }
}
