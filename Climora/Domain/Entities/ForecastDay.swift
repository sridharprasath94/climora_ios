import Foundation

struct ForecastDay {
    let date: String
    let minTemp: Double
    let maxTemp: Double
    let conditionCode: Int
    let conditionText: String

    var conditionIconName: String {
        switch conditionCode {
        case 1000: return "sun.max.fill"
        case 1003: return "cloud.sun.fill"
        case 1006, 1009: return "cloud.fill"
        case 1030, 1135, 1147: return "cloud.fog.fill"
        case 1063, 1150, 1153, 1180, 1183, 1240: return "cloud.drizzle.fill"
        case 1186, 1189, 1243: return "cloud.rain.fill"
        case 1192, 1195, 1246: return "cloud.heavyrain.fill"
        case 1066, 1210, 1213, 1216, 1219, 1255, 1258: return "cloud.snow.fill"
        case 1222, 1225: return "snowflake"
        case 1087, 1273, 1276, 1279, 1282: return "cloud.bolt.fill"
        default: return "cloud.fill"
        }
    }

    var dayLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date) else { return self.date }
        if Calendar.current.isDateInToday(date) { return "Today" }
        let display = DateFormatter()
        display.dateFormat = "EEE"
        return display.string(from: date)
    }
}
