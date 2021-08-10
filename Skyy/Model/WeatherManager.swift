import Foundation
import emojidataios
import SwiftyJSON

protocol WeatherManagerDelegate {
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
	func didFailWithError(error: Error?)
}

struct WeatherManager {
	
	let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=imperial"
	
	var delegate: WeatherManagerDelegate?
	
	func apiKey() -> String {
		let key = Constants()
		return key.apiKey
	}
	
	func fetchWeather(cityName: String) {
		let URL = "\(weatherURL)&appid=\(apiKey())&q=\(cityName)"
		guard let urlString = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {fatalError("Error converting URL to String.")}
		performRequest(with: urlString)
	}
	
	func fetchWeather(latitude: Double, longitude: Double) {
		let urlString = "\(weatherURL)&appid=\(apiKey())&lat=\(latitude)&lon=\(longitude)"
		performRequest(with: urlString)
	}
	
	func performRequest(with urlString: String) {
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { data, response, error in
				if error != nil {
					delegate?.didFailWithError(error: error)
					return
				}
				
				if let safeData = data {
					do {
						let json = try JSON(data: safeData)
						let id = json["weather"]["0"]["id"].intValue
						let temp = json["main"]["temp"].doubleValue
						let name = json["name"].stringValue
						let country = json["sys"]["country"].stringValue.lowercased()
						let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, country: country)
						json["name"].exists() ? delegate?.didUpdateWeather(self, weather: weather) : delegate?.didFailWithError(error: error)
					} catch {
						print("Error parsing json data: \(error)")
					}
				}
			}
			task.resume()
		}
	}
}
