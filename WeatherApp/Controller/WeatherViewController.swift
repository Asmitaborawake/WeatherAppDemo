//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mac on 03/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController , CLLocationManagerDelegate , chageCityDelegate{
    
    
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    let appID = "2c8700db6c9fde5963c04504c25247b2"
    
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    
    let locationManager = CLLocationManager()
    let wetherDataModelObject = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    //MARK: Networking
    //write getWeatherData method here
    func getWeatherData(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters:parameters).responseJSON{response in
            if response.result.isSuccess{
                print("get weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
            }else{
                print("error\(String(describing: response.result.error))")
                self.cityLbl.text = "Connection issue please check"
            }
            
        }
    }
    
    //MARK: JSON Parsing
    //write updatewether data method
    func updateWeatherData(json:JSON){
        if let tempResult = json["main"]["temp"].double{
            wetherDataModelObject.temprature = Int(tempResult - 273.15)
            wetherDataModelObject.city = json["name"].stringValue
            wetherDataModelObject.condition = json["weather"][0]["id"].intValue
            wetherDataModelObject.weatherIconName = wetherDataModelObject.updateWeatherIcon(condition: wetherDataModelObject.condition)
            updateUIWeatherData()
        }else {
            cityLbl.text = "Weather unavilable"
        }
    }
    
    
    //MARK: UpdateUI
    //updateuiwetherdata method here
    func updateUIWeatherData(){
        cityLbl.text = wetherDataModelObject.city
        tempLbl.text = "\(wetherDataModelObject.temprature)°"
        weatherIcon.image = UIImage(named: wetherDataModelObject.weatherIconName)
        
    }
    
    //MARK: Chnage city delegate method
    func userEnterNewCityName(city: String) {
        print(city)
        
        let parems : [String:String] = ["q" :  city , "appid" : appID]
        getWeatherData(url: weatherURL, parameters: parems)
    }
    
    //segue method call here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chnageCityName"{
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
            
        }
    }
    //MARK: Location manager delegate method
    
    //didupdate location method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            
            print("logitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let logitude = String(location.coordinate.longitude)
            
            let param : [String:String] = ["lat" : latitude , "lon" : logitude , "appid" : appID]
            getWeatherData(url: weatherURL, parameters: param)
        }
    }
    
    //didfailwitherror method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLbl.text = "Location unavilablel"
    }
   
    
}

