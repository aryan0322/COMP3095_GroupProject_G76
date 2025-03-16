import SwiftUI

@main
struct ShoppingListApp: App {
    let persistenceController = PersistenceController.shared // ✅ Core Data Persistence
    
    @State private var showLaunchScreen = true // ✅ Launch Screen Control

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.context) // ✅ Provide Core Data context
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
