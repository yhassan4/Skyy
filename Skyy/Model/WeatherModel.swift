import Foundation
import emojidataios

struct WeatherModel {
	let conditionId: Int
	let cityName: String
	let temperature: Double
	let country: String
	
	var temperatureString: String {
		return String(format: "%.1f", temperature)
	}
	
	var line: String {
		switch conditionId {
		case 200...240 :
			return "Stay safe out there\(EmojiParser.parseAliases(":zap:"))"
		case 300...330 :
			return "Make sure to grab an umbrella\(EmojiParser.parseAliases(":umbrella_with_rain_drops:"))"
		case 500...540 :
			return "Make sure to grab an umbrella\(EmojiParser.parseAliases(":umbrella_with_rain_drops:"))"
		case 600...630 :
			return "Make sure to grab your snow boots\(EmojiParser.parseAliases(":snowflake:"))"
		case 701...790 :
			return "It's kind of foggy out there\(EmojiParser.parseAliases(":fog:"))"
		case 800 :
			return "It's a beautiful day\(EmojiParser.parseAliases(":sunny:"))"
		case 801...804 :
			return "Stay safe out there\(EmojiParser.parseAliases(":zap:"))"
		default:
			return "Cloudy\(EmojiParser.parseAliases(":cloud:"))"
		}
	}
	
	var conditionName: String {
		switch conditionId {
		case 200...240 :
			return "cloud.bolt"
		case 300...330 :
			return "cloud.drizzle"
		case 500...540 :
			return "cloud.rain"
		case 600...630 :
			return "cloud.snow"
		case 701...790 :
			return "cloud.fog"
		case 800 :
			return "sun.max"
		case 801...804 :
			return "cloud.bolt"
		default:
			return "cloud"
		}
	}
	
}
