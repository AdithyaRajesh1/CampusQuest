import SwiftUI

struct AddChallenge: View {
    var cats = ["Social", "Study", "Fitness", "Explore", "Random"]
    @State var challTxt = ""
    @State var selectedCat = "Random"
    @State var msg = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Create a challenge", text: $challTxt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Picker("Category", selection: $selectedCat) {
                    ForEach(cats, id: \.self) { c in
                        Text(c)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Button("Submit") {
                    sendIt()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)

                Text(msg)
                    .padding()
                    .foregroundColor(.gray)

                Spacer()
            }
            .navigationTitle("Submit")
        }
    }

    func sendIt() {
        if challTxt.trimmingCharacters(in: .whitespaces) == "" {
            msg = "type something first"
            return
        }
        sendChall(txt: challTxt, cat: selectedCat) { ok in
            if ok {
                msg = "submitted"
                challTxt = ""
            } else {
                msg = "couldnt submit"
            }
        }
    }
}
