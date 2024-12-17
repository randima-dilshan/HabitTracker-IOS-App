import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = HabitViewModel() // ViewModel to manage habits
    @State private var showAddHabit = false // To show Add Habit screen
    @State private var selectedHabit: HabitEntity? // The habit to be edited or deleted
    
    var body: some View {
        NavigationStack {
            VStack {
                // Habit List Section
                List {
                    ForEach(viewModel.habits, id: \.id) { habitEntity in
                        let habit = Habit(from: habitEntity)
                        HStack {
                            HabitCard(habit: habit)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.incrementStreak(for: habitEntity) // Increment streak
                                    }
                                }
                                .onLongPressGesture {
                                    viewModel.resetStreak(for: habitEntity) // Reset streak
                                }

                            Spacer()

                            // Edit Button
                            Button(action: {
                                // Set the habit to be edited
                                selectedHabit = habitEntity
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle()) // Avoid interference with gestures

                            // Delete Button
                            Button(action: {
                                // Directly delete the habit without affecting selectedHabit
                                viewModel.deleteHabit(habitEntity)
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle()) // Avoid interference with gestures
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(PlainListStyle()) // Optional: Use plain style for a clean look

                // "Graph" Button
                NavigationLink(destination: GraphView(viewModel: viewModel)) {
                    Text("View Graph")
                        .font(.title3) // Reduced font size
                        .padding(12)    // Reduced padding
                        .frame(width: 280) // Reduced button width
                        .background(Color.blue.opacity(0.6)) // Light Blue Color
                        .foregroundColor(.white) // Text Color - Blue
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom) // Padding to separate the button from the list

                // "View Stats" Button
                NavigationLink(destination: StatsView(viewModel: viewModel)) {
                    Text("View Stats")
                        .font(.title3) // Reduced font size
                        .padding(12)    // Reduced padding
                        .frame(width: 280) // Reduced button width
                        .background(Color.green.opacity(0.6)) // Lift Green Color
                        .foregroundColor(.white) // Text Color - Green
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom) // Padding to separate the button from the list

            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                Button {
                    showAddHabit = true // Show Add Habit screen
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView(viewModel: viewModel)
            }
            .sheet(item: $selectedHabit) { habitEntity in
                EditHabitView(viewModel: viewModel, habit: habitEntity) // Pass the habit for editing
            }
        }
        .onAppear {
            viewModel.fetchHabits() // Load habits when the view appears
        }
    }
}

struct SplashScreenWrapper_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenWrapper()
    }
}
