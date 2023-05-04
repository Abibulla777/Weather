//
//  ViewController.swift
//  Weather
//
//  Created by abibulla on 27.04.2023.
//

import UIKit
import CoreLocation
import Alamofire


class ViewController: UIViewController, CLLocationManagerDelegate, GetWeatherViewControllerDelegate {
    
    var temperature = 0
    
    @IBOutlet weak var weatherPressureLabel: UILabel!
    
    @IBOutlet weak var humidityWeatherLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var gustWindLabel: UILabel!
    
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    public let WEATHER_URL: String = "https://api.openweathermap.org/data/2.5/weather"
    public let API_KEY: String = "8b9f776f695b68ae7da0bef7865b0554"
    
    //чтобы работать с местоположением
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        //когда, программа открывается, он сразу запускает поиск по геолокаций
        locationManager.startUpdatingLocation()
        
    }
    
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if sender.isOn == true {
            let result = (temperature * 9 / 5) + 32
            temperatureLabel.text = String(result)
        } else {
            temperatureLabel.text = String(temperature)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //массив с локациями
        let location = locations[locations.count-1]
        //проверка на корректность местоположения
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("LOCATIONS: \(location)")
            let params: [String: Any] = ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude, "appid": API_KEY, "units": "metric"]
            getWeatherData(url: WEATHER_URL, params: params)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
        cityNameLabel.text = "Локация не найдена"
    }
    
    
    func getWeatherData(url: String, params: [String: Any]) {
        //замыкание, которое делает запрос на сервер
        AF.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success( _ ):
                do {
                    if let responseData = response.data {
                        print(response)
                        let json = try JSONDecoder().decode(WeatherModel.self, from: responseData)
                        print(json)
                        self.temperature = Int(json.main.temp)
                        self.updateUI(json: json)
                    } else {
                        print("Ошибка при декодировании")
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func updateUI(json: WeatherModel) {
        //название города
        cityNameLabel.text = json.name
        //температура в этом городе
        temperatureLabel.text = "\(json.main.temp)"
        weatherPressureLabel.text = "\(json.main.pressure)"
        humidityWeatherLabel.text = "\(json.main.humidity)"
        windSpeedLabel.text = "\(json.wind.gust)"
        gustWindLabel.text = "\(json.wind.speed)"
        
        weatherConditionImageView.image = UIImage(named: updateWeatherIcon(condition: json.weather.first?.id ?? -1))
    }
    //функция для обновления картинок
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
        case 0...300:
            return "tstorm 1"
        case 301...500:
            return "light_rain"
        case 501...600:
            return "shower3"
        case 601...700:
            return "snow4"
        case 701...771:
            return "fog"
        case 772...799:
            return "tstorm3"
        case 800:
            return "sunny"
        case 801...804:
            return "overcast"
        case 900...903, 905...1000:
            return "tstorm4"
        default:
            return "undefined"
        }
        
    }
    func getWeatherForCity(with name: String) {
        let params: [String: Any] = ["q": name, "appid": API_KEY, "units": "metric"]
        getWeatherData(url: WEATHER_URL, params: params)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city" {
            if let destination = segue.destination as? GetWeatherViewController {
                destination.delegate = self
            }
        }
    }


}

