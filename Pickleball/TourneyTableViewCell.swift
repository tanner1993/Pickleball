//
//  TourneyTableViewCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 8/27/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class TourneyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tourneyname: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
