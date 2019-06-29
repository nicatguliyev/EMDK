//
//  MuracietCell.swift
//  EMDK
//
//  Created by Nicat Guliyev on 6/25/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class MuracietCell: UITableViewCell {
    
    
    @IBOutlet weak var muracietName: UILabel!
    @IBOutlet weak var muracietDate: UILabel!
    @IBOutlet weak var muracietView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
