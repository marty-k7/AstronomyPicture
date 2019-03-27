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
import EasyPopUp

class ViewController: UIViewController {
    
    let BASE_URL = "https://api.nasa.gov/planetary/apod?api_key="
    let API_KEY = AstronomyPictureOfTheDayKeys().nasaApiKey

    @IBOutlet weak var bg: UIImageView!
    
    var img: UIImage?
    var infoText: String?
    
    
    // animated popup vc
    lazy var viewControllerPopup : EasyViewControllerPopup = {
        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "vcpopup") as! popUpVC
        popupVC.data = infoText
        let easePopUp = EasyViewControllerPopup(sourceViewController: self, destinationViewController: popupVC )
        return easePopUp
    }()
 
 
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(on: self.view)
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
            self.bg.contentMode = .scaleAspectFill
            self.img = image
            self.removeSpinner()
            
        }
    }
    //MARK: - JSON Parsing
    
    func updateUI(with json: JSON) {
        
        if let url = json["url"].string {
            getImage(from: url)
        }
        if let info = json["explanation"].string {
            infoText = info
            
        } else {
            print("Error with parsing ")
        }
    }
    
    
    @IBAction func discovery(_ sender: UIButton) {
        viewControllerPopup.showVCAsPopup()

    }
    
    
    //MARK: - Image saving
    //================================================
    
//https://stackoverflow.com/questions/40854886/swift-take-a-photo-and-save-to-photo-library
    
    @IBAction func save(_ sender: UIButton) {
        guard let selectedImg = img else {
            showAlertWith(title: "Save error", message: "Image not found")
            return
        }
     UIImageWriteToSavedPhotosAlbum(selectedImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    //MARK:- Sharing
    
    @IBAction func share(_ sender: UIButton) {
        if let image = img {
            let actionController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(actionController, animated: true, completion: nil)
        } else {
            showAlertWith(title: "Oops!", message: "Picture canot be shared")
        }
    }
}
//MARK: - Reuseable spinner

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(on view : UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            view.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
