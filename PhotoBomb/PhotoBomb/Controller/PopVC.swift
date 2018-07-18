//
//  PopVC.swift
//  PhotoBomb
//
//  Created by Sehajbir Randhawa on 7/18/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class PopVC: UIViewController,UIGestureRecognizerDelegate {

    //Outlets
    @IBOutlet weak var image: UIImageView!
    
    //Variables
    var passedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = passedImage
        addDoubleTap()

      
    }
    
    func addDoubleTap(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(PopVC.screenDismiss(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func screenDismiss(_ recog: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    func setData(image: UIImage){
        self.passedImage = image
    }
}
