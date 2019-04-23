//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Mac on 03/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

//write protocol declaration here
protocol chageCityDelegate {
    func userEnterNewCityName(city:String)
}

class ChangeCityViewController: UIViewController {
    
    @IBOutlet weak var chnageCityTextField: UITextField!
    
    //declare delegte veriable
    var delegate : chageCityDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getWeatherData(_ sender: Any) {
        let cityName = chnageCityTextField.text!
        delegate?.userEnterNewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
