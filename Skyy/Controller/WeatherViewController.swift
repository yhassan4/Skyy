import UIKit
import CoreLocation
import emojidataios
import MapKit

class WeatherViewController: UIViewController {
	
	@IBOutlet weak var conditionImageView: UIImageView!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchText: UITextField!
	@IBOutlet weak var line: UILabel!
	
	var weatherManager = WeatherManager()
	let locationManager = CLLocationManager()
	var suggestions = [MKLocalSearchCompletion]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		
		weatherManager.delegate = self
		searchText.delegate = self
		
		EmojiParser.prepare()
	}
	
	@IBAction func locationPressed(_ sender: UIButton) {
		locationManager.requestLocation()
	}
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
	
	@IBAction func searchPressed(_ sender: UIButton) {
		searchText.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchText.endEditing(true)
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			searchText.placeholder = "Enter a city..."
			return false
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		if let city = searchText.text {
			weatherManager.fetchWeather(cityName: city)
		}
		
		searchText.text = ""
	}
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
	
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
		
		DispatchQueue.main.async {
			self.temperatureLabel.text = weather.temperatureString
			self.conditionImageView.image = UIImage(systemName: weather.conditionName)
			self.cityLabel.text = weather.cityName + EmojiParser.parseAliases(":flag-\(weather.country):")
			self.line.text = weather.line
		}
	}
	
	func didFailWithError(error: Error?) {
		DispatchQueue.main.async {
			self.temperatureLabel.text = "?"
			self.conditionImageView.image = UIImage(systemName: "cloud")
			self.cityLabel.text = "Invalid city"
			self.line.text = "Please try again"
		}
	}
}

//MARK: - LocationDelegate

extension WeatherViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			locationManager.stopUpdatingLocation()
			let lat = location.coordinate.latitude
			let lon = location.coordinate.longitude
			weatherManager.fetchWeather(latitude: lat, longitude: lon)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error locating: \(error)")
	}
}

