import SwiftUI

// Splash screen view
struct SplashScreenView: View {
    @Binding var isActive: Bool // Binding to control when splash screen disappears
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all) // Full screen background

            VStack {
                Image(systemName: "flame.fill") // Example logo, replace with your logo
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .padding(.bottom, 20)

                Text("Habit Tracker App")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                // Optional: Add a progress indicator or animation if you'd like
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 20)
            }
        }
        .onAppear {
            // Trigger navigation after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.isActive = false // Hide splash screen and navigate to ContentView
                }
            }
        }
    }
}

// Splash Screen Wrapper: Controls whether to show splash screen or main content
struct SplashScreenWrapper: View {
    @State private var isActive = true // State to control splash screen visibility
    
    var body: some View {
        if isActive {
            SplashScreenView(isActive: $isActive) // Pass isActive as a Binding
        } else {
            ContentView() // Navigate to the main content view after splash screen
        }
    }
}
