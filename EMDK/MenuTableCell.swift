//
//  MenuTableCell.swift
//  EMDK
//
//  Created by Nicat Guliyev on 12/19/18.
//  Copyright © 2018 Nicat Guliyev. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {

    @IBOutlet weak var menuNameLbl: UILabel!
    @IBOutlet weak var menuImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

 
    }

}
