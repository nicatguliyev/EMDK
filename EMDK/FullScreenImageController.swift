//
//  FullScreenImageController.swift
//  EMDK
//
//  Created by Nicat Guliyev on 4/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class FullScreenImageController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        scrollView.delegate = self
        
        imageView.image = selectedImage

    }
    @IBAction func backClicked(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    



}
