import Foundation

struct WeatherData: Codable {
	let name: String
	let weather: [Weather]
	let main: Main
	let sys: Sys
}

struct Weather: Codable {
	let id: Int
}

struct Main: Codable {
	let temp: Double
}

struct Sys: Codable {
	let country: String
}
