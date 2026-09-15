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
                        if item.lat != nil && item.lng != nil {
                            Text("lat: \(item.lat!) lng: \(item.lng!)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
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
