//
//  FilterCell.swift
//  CarDude
//
//  Created by Raitis Saripo on 16/03/2021.
//

import UIKit
import DropDown

class FilterCell: DropDownCell {
    
    @IBOutlet var filterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        filterImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
