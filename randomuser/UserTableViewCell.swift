//
//  UserTableViewCell.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/06.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var label_Name: UILabel!
    @IBOutlet weak var label_Gender: UILabel!
    @IBOutlet weak var label_Nat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
