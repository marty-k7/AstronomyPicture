//
//  ViewController.swift
//  Astronomy-picture-of-the-day
//
//  Created by Martynas Klastaitis  on 22/03/2019.
//  Copyright © 2019 bajoraiciuprodukcija. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Keys

class ViewController: UIViewController {
    
    let BASE_URL = "https://api.nasa.gov/planetary/apod?api_key="
    let API_KEY = AstronomyPictureOfTheDayKeys().nasaApiKey

    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImageData()

    }
    
    //MARK: - Networking
    
    func getImageData() {
        Alamofire.request(BASE_URL + API_KEY, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let imageData : JSON = JSON(response.result.value!)
                self.updateUI(with: imageData)
            }
        }
    }
    
    func getImage(from url: String)  {
        Alamofire.request(url).responseImage { response in
            
//            debugPrint(response)
//            print(response.request!)
//            print(response.response!)
//            debugPrint(response.result)
//
            guard let image = response.result.value  else {
                print("Error getting image")
                return
            }
            self.bg.image = image
            self.bg.contentMode = .scaleAspectFit
            
        }
    }
    //MARK: - JSON Parsing
    
    func updateUI(with json: JSON) {
        
        if let url = json["url"].string {
            getImage(from: url)
        } else {
            print("Some error with parsing  ")
        }
    }
    
}

