//
//  EpisodesTableViewCell.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 17/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class EpisodesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageEpisode: UIImageView!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(with episode: Episode) {
        episodeNumberLabel.text = "Episode \(episode.number)"
        titleLabel.text = episode.name
        if let imageUrl = episode.image?.medium, let url = URL(string: imageUrl) {
            imageEpisode.kf.indicatorType = .activity
            imageEpisode.kf.setImage(with: url)
        } else {
            imageEpisode.image = #imageLiteral(resourceName: "logo")
        }
        
        imageEpisode.layer.cornerRadius = 2.0
        imageEpisode.layer.borderColor = UIColor(named: "pinkish")!.cgColor
        imageEpisode.layer.borderWidth = 2
    }
}
