import Foundation

var apiURL = "http://127.0.0.1:5050"
var userId = ""
var token = ""

struct Chall: Codable {
    var id: Int
    var text: String
    var category: String
}

struct DoneItem: Codable, Identifiable {
    var id: Int
    var text: String
    var completed_at: String
    var lat: Double?
    var lng: Double?
}

struct LoginStuff: Codable {
    var access_token: String
    var user_id: String
}

func loginUser(email: String, password: String, done: @escaping (Bool, String) -> Void) {
    let url = URL(string: apiURL + "/login")!
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let stuff = ["email": email, "password": password]
    req.httpBody = try? JSONSerialization.data(withJSONObject: stuff)
    URLSession.shared.dataTask(with: req) { data, resp, err in
        if data == nil {
            DispatchQueue.main.async {
                done(false, "login failed")
            }
            return
        }
        let decoded = try? JSONDecoder().decode(LoginStuff.self, from: data!)
        if decoded != nil {
            if decoded!.access_token != "" {
                token = decoded!.access_token
                userId = decoded!.user_id
                DispatchQueue.main.async {
                    done(true, "")
                }
                return
            }
        }
        DispatchQueue.main.async {
            done(false, "login failed")
        }
    }.resume()
}

func signupUser(email: String, password: String, done: @escaping (Bool, String) -> Void) {
    let url = URL(string: apiURL + "/signup")!
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let stuff = ["email": email, "password": password]
    req.httpBody = try? JSONSerialization.data(withJSONObject: stuff)
    URLSession.shared.dataTask(with: req) { data, resp, err in
        if data == nil {
            DispatchQueue.main.async {
                done(false, "signup failed")
            }
            return
        }
        let decoded = try? JSONDecoder().decode(LoginStuff.self, from: data!)
        if decoded != nil {
            if decoded!.access_token != "" {
                token = decoded!.access_token
                userId = decoded!.user_id
                DispatchQueue.main.async {
                    done(true, "")
                }
                return
            } else {
                DispatchQueue.main.async {
                    done(false, "try logging in")
                }
                return
            }
        }
        DispatchQueue.main.async {
            done(false, "signup failed")
        }
    }.resume()
}

func getRandomChall(done: @escaping (Chall?) -> Void) {
    let url = URL(string: apiURL + "/challenges/random")
    if url == nil {
        done(nil)
        return
    }
    var req = URLRequest(url: url!)
    if token != "" {
        req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    }
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

func saveDone(challId: Int, lat: Double?, lng: Double?, done: @escaping (Bool) -> Void) {
    let url = URL(string: apiURL + "/completions")
    if url == nil {
        done(false)
        return
    }
    var req = URLRequest(url: url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    var body: [String: Any] = ["challenge_id": challId]
    if lat != nil && lng != nil {
        body["lat"] = lat!
        body["lng"] = lng!
    }
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
    req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
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

func computeStreak(items: [DoneItem]) -> Int {
    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "yyyy-MM-dd"
    dayFormatter.timeZone = TimeZone(identifier: "UTC")
    let calendar = Calendar(identifier: .gregorian)

    var days = Set<Date>()
    for item in items {
        let prefix = String(item.completed_at.prefix(10))
        if let date = dayFormatter.date(from: prefix) {
            days.insert(date)
        }
    }

    var day = dayFormatter.date(from: dayFormatter.string(from: Date()))!
    if !days.contains(day) {
        day = calendar.date(byAdding: .day, value: -1, to: day)!
    }

    var streak = 0
    while days.contains(day) {
        streak += 1
        day = calendar.date(byAdding: .day, value: -1, to: day)!
    }
    return streak
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
    req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    let body: [String: Any] = ["text": txt, "category": cat]
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
