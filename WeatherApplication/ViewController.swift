//
//  ViewController.swift
//  WeatherApplication
//
//  Created by 라완 💕 on 11/05/1444 AH.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource  , UICollectionViewDelegate {
    
    @IBOutlet weak var weatherDetile: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var nearestStorm: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var preciptation: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var firstCollection: UICollectionView!
    @IBOutlet weak var secondCollection: UICollectionView!
    @IBOutlet weak var imageCloud: UIImageView!
    
    var wData: Weatherdata?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromApi()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == firstCollection {
            print(wData?.daily.count ?? 0)
            
        }
        print(wData?.daily.count ?? 0)
        return wData?.daily.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = secondCollection.dequeueReusableCell(withReuseIdentifier: "BCollectionViewCell", for: indexPath) as! BCollectionViewCell
        
        guard let weatherData = wData else { return UICollectionViewCell() }

        cell.settempCell(
            day: fromDtToformatedDate(dt: Double (weatherData.daily[indexPath.row].dt ), foramt : "EEEE" ),
            theWeather: "\(weatherData.daily[indexPath.row].weather[0].weatherDescription )",
            min: "\(self.ConvertKivToC(temperature : Double(weatherData.daily[indexPath.row].temp.min )))F↓",
            max: "\(self.ConvertKivToC(temperature : Double(weatherData.daily[indexPath.row].temp.max )))F↑",
            image: self.getWeatherStatusImg( status: weatherData.daily[indexPath.row].weather[0].main.rawValue )
        )


        if collectionView == firstCollection {
            let cell2 = firstCollection.dequeueReusableCell(withReuseIdentifier: "ACollectionViewCell", for: indexPath) as! ACollectionViewCell
          
            cell2.settempCell(
                time: fromDtToformatedDate(dt: Double (weatherData.hourly[indexPath.row].dt ) , foramt : "h a" ),
                dgree: "\(self.ConvertKivToC(temperature : weatherData.daily[indexPath.row].temp.day))F"
            )
            return cell2
        }
        return cell
    }
    
    func fromDtToformatedDate(dt: Double, foramt : String ) -> String {

          let date = Date(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = foramt
          return dateFormatter.string(from: date)
      }
    func ConvertKivToC(temperature : Double)->String {
       return  "\(String(format: "%.0f", temperature - 273.15))°"
    }
    
    func getWeatherStatusImg(status : String )->UIImage {
       
        switch status {
        case "Clouds":
            return UIImage(systemName: "cloud.fill")!
        case "Rain":
            return  UIImage(systemName: "cloud.rain.fill")!
        case "Clear":
            return UIImage(systemName: "sun.max")!
        case "Snow":
            return UIImage(systemName: "cloud.snow.fill")!
        default:
            return UIImage(systemName: "cloud.snow.fill")!
        }
     
     }
    
    func getDataFromApi(){
        
        let jsonURLstring = "https://api.openweathermap.org/data/3.0/onecall?lat=21.266470&lon=40.463863&appid=ce44097f28eaf9c5fe412cd705f0cb34"
        guard let url = URL(string : jsonURLstring) else {return }
        URLSession.shared.dataTask(with: url) { data , response, errur in
            guard let data = data else {return }
            
           do {
               let watherData = try JSONDecoder().decode(Weatherdata.self ,from: data )
               self.wData = watherData

               DispatchQueue.main.async {
                   
                   let formatter = DateFormatter()
                           formatter.dateFormat = "hh:mm a"
                           let str = formatter.string(from: Date())
                   self.imageCloud.image = self.getWeatherStatusImg( status: watherData.hourly[0].weather[0].main.rawValue )
                   self.weatherDetile.text = "\(watherData.current.weather[0].weatherDescription)"
                   self.city.text = watherData.timezone
                   self.time.text = "time: \(str)"
                   self.windSpeed.text = "windspeed: \(String(watherData.current.windSpeed)) MPH"
                   self.humidity.text = "humidity: \(String(watherData.current.humidity))%"
                   self.nearestStorm.text = "nearest storm: 75 miles"
                   
                   self.cloudCover.text = "cloud cover: \(String(watherData.current.clouds))%"
                   self.preciptation.text = "precipition probability: 0.0%"
                   self.feelsLike.text = "feels like: \(String(watherData.current.feelsLike))º"
                
                   //print(watherData.timezoneOffset)
                   self.firstCollection.reloadData()
                   self.secondCollection.reloadData()
               }
            print (self.wData?.daily ?? 0)
           }catch let jsonErr{
               print("Error :" ,jsonErr )
           }
       }
        .resume()
    }

    
}


