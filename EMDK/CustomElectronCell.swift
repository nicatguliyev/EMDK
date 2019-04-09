//
//  CustomElectronCell.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/19/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class CustomElectronCell: UITableViewCell {
    
    @IBOutlet weak var xidmetNameLbl: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var subItemLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var favImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      //  nameView.layer.cornerRadius = 10
       // contentView.layer.cornerRadius = 10
     //   contentView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
