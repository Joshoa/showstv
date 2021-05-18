//
//  EpisodeViewController.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 17/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    @IBOutlet weak var imageEpisode: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    
    var episode: Episode!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEpisodeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navBarColor = UIColor(named: "pinkish")!
        let navBarTextColor: UIColor = .white
        let tabBarColor = UIColor(named: "pinkish")!
        
        configureNavigationBar(largeTitleColor: navBarTextColor, backgoundColor: navBarColor, tintColor: navBarTextColor, title: "Episode \(episode.number)", preferredLargeTitle: false)
        configTabBar(selectedColor: tabBarColor, unselectedColor: tabBarColor, viewController: self)
    }
    
    func loadEpisodeView() {
        if let imageUrl = episode.image?.original, let url = URL(string: imageUrl) {
            imageEpisode.kf.setImage(with: url)
        } else {
            imageEpisode.image = #imageLiteral(resourceName: "logo")
        }
        
        titleLabel.text = episode.name
        seasonLabel.text = "Season \(episode.season)"
        summaryTextView.attributedText = episode.summary?.htmlAttributedString(colorHex: "#000000")
    }
}
