//
//  HTCell.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//

import UIKit

class HTCell: UITableViewCell {
    
    @IBOutlet weak var startTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
