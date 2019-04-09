//
//  CustomFavCell.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/20/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class CustomFavCell: UITableViewCell {

  
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var favName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
