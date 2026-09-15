import SwiftUI

struct HomeScreen: View {
    var challList = [
        "Wear your FASET shirt for a day",
        "No airpods for a day and walk around",
        "Get coffee with 4 shots of espresso",
        "Find a new building you've never seen",
        "Do 20 jumping jacks on tech green",
        "Compliment a Kaldi's barista",
        "Take a photo of a friend without them knowing and send it to them",
        "Get someone's insta without telling them your name",
        "Meet someone from India Club"
    ]

    @State var challengeTxt = "Get Challenge"
    @State var currentId = 0
    @StateObject var loc = LocHelper()

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
                    getChall()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)

                HStack {
                    Button("Complete") {
                        completeChall()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)

                    Button("Skip") {
                        getChall()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(8)
                }
                .padding(.top, 8)

                Spacer()
            }
            .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }

    func getChall() {
        getRandomChall { chall in
            if chall != nil {
                challengeTxt = chall!.text
                currentId = chall!.id
            } else {
                let i = Int.random(in: 0..<challList.count)
                challengeTxt = challList[i]
                currentId = 0
            }
        }
    }

    func completeChall() {
        if currentId == 0 {
            getChall()
            return
        }
        saveDone(challId: currentId, lat: loc.lat, lng: loc.lng) { ok in
            getChall()
        }
    }
}
