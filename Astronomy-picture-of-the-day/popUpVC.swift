//
//  popUpVC.swift
//  Astronomy-picture-of-the-day
//
//  Created by Martynas Klastaitis  on 25/03/2019.
//  Copyright © 2019 bajoraiciuprodukcija. All rights reserved.
//

import UIKit
import EasyPopUp

class popUpVC: UIViewController {
    
    var data: String?
    
    @IBOutlet weak var popupContentView: UIView! {
        didSet {
            popupContentView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var dismissBtn: UIButton! {
        didSet {
            dismissBtn.layer.cornerRadius = dismissBtn.frame.height/2
        }
    }
    
    
    override func viewDidLoad() {
        textView.text = data ?? "No info"
    }

    @IBAction func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        }
}
    
extension popUpVC: EasyPopUpViewControllerDatasource {
    var popupView: UIView {
        return popupContentView
    }
    
}
