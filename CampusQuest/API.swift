import Foundation

var apiURL = "http://127.0.0.1:5050"
var userId = "adithya"

struct Chall: Codable {
    var id: Int
    var text: String
    var category: String
}

struct DoneItem: Codable, Identifiable {
    var id: Int
    var text: String
    var completed_at: String
}

func getRandomChall(done: @escaping (Chall?) -> Void) {
    let url = URL(string: apiURL + "/challenges/random")
    if url == nil {
        done(nil)
        return
    }
    var req = URLRequest(url: url!)
    req.setValue(userId, forHTTPHeaderField: "X-User-Id")
    URLSession.shared.dataTask(with: req) { data, resp, err in
        if err != nil || data == nil {
            DispatchQueue.main.async {
                done(nil)
            }
            return
        }
        let decoded = try? JSONDecoder().decode(Chall.self, from: data!)
        DispatchQueue.main.async {
            done(decoded)
        }
    }.resume()
}

func saveDone(challId: Int, done: @escaping (Bool) -> Void) {
    let url = URL(string: apiURL + "/completions")
    if url == nil {
        done(false)
        return
    }
    var req = URLRequest(url: url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue(userId, forHTTPHeaderField: "X-User-Id")
    let body: [String: Any] = ["challenge_id": challId, "user_id": userId]
    req.httpBody = try? JSONSerialization.data(withJSONObject: body)
    URLSession.shared.dataTask(with: req) { data, resp, err in
        var ok = false
        if let http = resp as? HTTPURLResponse {
            if http.statusCode == 201 {
                ok = true
            }
        }
        DispatchQueue.main.async {
            done(ok)
        }
    }.resume()
}

func getDoneList(done: @escaping ([DoneItem]) -> Void) {
    let url = URL(string: apiURL + "/completions/" + userId)
    if url == nil {
        done([])
        return
    }
    var req = URLRequest(url: url!)
    req.setValue(userId, forHTTPHeaderField: "X-User-Id")
    URLSession.shared.dataTask(with: req) { data, resp, err in
        var items: [DoneItem] = []
        if data != nil {
            if let decoded = try? JSONDecoder().decode([DoneItem].self, from: data!) {
                items = decoded
            }
        }
        DispatchQueue.main.async {
            done(items)
        }
    }.resume()
}

func sendChall(txt: String, cat: String, done: @escaping (Bool) -> Void) {
    let url = URL(string: apiURL + "/challenges")
    if url == nil {
        done(false)
        return
    }
    var req = URLRequest(url: url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue(userId, forHTTPHeaderField: "X-User-Id")
    let body: [String: Any] = ["text": txt, "category": cat, "created_by": userId]
    req.httpBody = try? JSONSerialization.data(withJSONObject: body)
    URLSession.shared.dataTask(with: req) { data, resp, err in
        var ok = false
        if let http = resp as? HTTPURLResponse {
            if http.statusCode == 201 {
                ok = true
            }
        }
        DispatchQueue.main.async {
            done(ok)
        }
    }.resume()
}
