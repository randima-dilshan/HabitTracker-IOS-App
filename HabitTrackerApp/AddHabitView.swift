import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode // To close the screen
    @ObservedObject var viewModel: HabitViewModel // The ViewModel to add habits

    @State private var habitName = "" // Text field for the habit name

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.green.opacity(0.4)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea() // Cover the entire screen

            VStack(spacing: 20) {
                // Optional Illustration/Icon
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .padding(.top, 40)

                Text("Add a New Habit")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                // Form-Like Card with Rounded Corners
                VStack(spacing: 16) {
                    // TextField with Styling
                    TextField("Enter Habit Name", text: $habitName)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    // Add Button
                    Button(action: {
                        if !habitName.isEmpty {
                            viewModel.addHabit(name: habitName)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add Habit")
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

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(viewModel: HabitViewModel())
    }
}
