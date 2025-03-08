import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Image(systemName: "cart.fill") // Replace with your logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)

                Text("Shopping List App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("Created by G-76 (Aryan Patel – 101414520 – 50492)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
