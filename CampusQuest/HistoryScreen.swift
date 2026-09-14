import SwiftUI

struct HistoryScreen: View {
    @State var doneList: [DoneItem] = []

    var body: some View {
        NavigationView {
            VStack {
                if doneList.count == 0 {
                    Text("No completed challenges yet")
                        .foregroundColor(.gray)
                        .padding()
                }
                List(doneList) { item in
                    VStack(alignment: .leading) {
                        Text(item.text)
                        Text(item.completed_at)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("History")
            .onAppear {
                loadDone()
            }
        }
    }

    func loadDone() {
        getDoneList { items in
            doneList = items
        }
    }
}
