//
//  GetWeatherViewController.swift
//  Weather
//
//  Created by abibulla on 27.04.2023.
//

import UIKit
protocol GetWeatherViewControllerDelegate: NSObjectProtocol {
    func getWeatherForCity(with name: String)
}



class GetWeatherViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    
    @IBOutlet weak var getWeatherButton: UIButton!
    
    
    weak var delegate: GetWeatherViewControllerDelegate?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherButton.layer.cornerRadius = 5
        getWeatherButton.layer.masksToBounds = true
        
    }
    

    @IBAction func getWeatherPressed(_ sender: Any) {
        let cityName = inputTextField.text ?? "error"
//        guard let cityName2 = inputTextField.text else { return }
        delegate?.getWeatherForCity(with: cityName)
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
