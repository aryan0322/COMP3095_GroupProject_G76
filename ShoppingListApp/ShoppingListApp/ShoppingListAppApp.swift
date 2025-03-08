import SwiftUI

@main
struct ShoppingListApp: App {
    @State private var showLaunchScreen = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView() // Home Screen (Always in the background)
                    .opacity(showLaunchScreen ? 0 : 1) // Initially hidden
                    .animation(.easeInOut(duration: 1.5), value: showLaunchScreen) // Smooth fade-in

                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.opacity) // Fade-out effect
                        .animation(.easeInOut(duration: 1.5), value: showLaunchScreen)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    showLaunchScreen = false // Triggers fade-out effect
                                }
                            }
                        }
                }
            }
        }
    }
}
