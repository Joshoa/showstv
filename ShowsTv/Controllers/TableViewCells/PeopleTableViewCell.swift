//
//  PeopleTableViewCell.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 18/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePerson: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(with person: Person, color: UIColor = UIColor(named: "secondary")!) {
        titleLabel.text = person.name
        if let imageUrl = person.image?.medium, let url = URL(string: imageUrl) {
            imagePerson.kf.indicatorType = .activity
            imagePerson.kf.setImage(with: url)
        } else {
            imagePerson.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(UIColor(named: "orangish")!)
        }
        
        imagePerson.layer.cornerRadius = imagePerson.frame.height/2
        imagePerson.layer.borderColor = color.cgColor
        imagePerson.layer.borderWidth = 2
        
    }

}
