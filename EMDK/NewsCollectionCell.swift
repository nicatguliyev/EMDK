//
//  NewsCollectionCell.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/20/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class NewsCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var newsNameLbl: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsDate: UILabel!
}
