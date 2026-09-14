import SwiftUI

struct HomeScreen: View {
    var challengeTxt = "Study somewhere you've never studied before."

    var body: some View {
        NavigationView {
            VStack {
                Text("Campus Quest")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 25)

                Spacer().frame(height: 35)

                VStack {
                    Text("Your challenge")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(challengeTxt)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()

                Button("Give Me a Challenge") {

                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)

                Spacer()
            }
            .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
}
