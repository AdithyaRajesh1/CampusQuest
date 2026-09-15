import Foundation

func getWeather(lat: Double, lng: Double, done: @escaping (String, Bool) -> Void) {
    let urlStr = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lng)&current=temperature_2m,weather_code&temperature_unit=fahrenheit"
    let url = URL(string: urlStr)
    if url == nil {
        done("weather unavailable", false)
        return
    }
    URLSession.shared.dataTask(with: url!) { data, resp, err in
        var txt = "weather unavailable"
        var raining = false
        if data != nil {
            let obj = try? JSONSerialization.jsonObject(with: data!) as? [String: Any]
            let current = obj?["current"] as? [String: Any]
            if current != nil {
                let temp = current!["temperature_2m"] as? Double
                let code = current!["weather_code"] as? Int
                var name = "idk"
                if code != nil {
                    name = weatherName(code: code!)
                    if (code! >= 51 && code! <= 67) || (code! >= 80 && code! <= 82) || (code! >= 95 && code! <= 99) {
                        raining = true
                    }
                }
                if temp != nil {
                    txt = "\(Int(temp!))°F and \(name)"
                } else {
                    txt = name
                }
            }
        }
        DispatchQueue.main.async {
            done(txt, raining)
        }
    }.resume()
}

func weatherName(code: Int) -> String {
    if code == 0 {
        return "sunny"
    }
    if code >= 1 && code <= 3 {
        return "cloudy"
    }
    if code == 45 || code == 48 {
        return "foggy"
    }
    if code >= 51 && code <= 67 {
        return "rainy"
    }
    if code >= 71 && code <= 77 {
        return "snowy"
    }
    if code >= 80 && code <= 82 {
        return "rainy"
    }
    if code >= 95 {
        return "stormy"
    }
    return "idk"
}
