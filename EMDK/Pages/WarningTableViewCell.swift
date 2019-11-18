//
//  WarningTableViewCell.swift
//  EMDK
//
//  Created by Nicat Guliyev on 6/23/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class WarningTableViewCell: UITableViewCell {

    @IBOutlet weak var errorName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
