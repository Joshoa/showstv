//
//  ShowsTableViewCell.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 16/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit
import Kingfisher

class ShowsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageShow: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(with show: Show, color: UIColor = UIColor(named: "pinkish")!) {
        titleLabel.text = show.name
        if let imageUrl = show.image?.medium, let url = URL(string: imageUrl) {
            imageShow.kf.indicatorType = .activity
            imageShow.kf.setImage(with: url)
        } else {
            imageShow.image = #imageLiteral(resourceName: "logo")
        }
        
        imageShow.layer.cornerRadius = 2.0
        imageShow.layer.borderColor = color.cgColor
        imageShow.layer.borderWidth = 2
        
    }

}
