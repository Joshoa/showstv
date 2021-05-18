//
//  ShowViewController.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 16/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var show: Show!
    var seasons: [Season] = []
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Loading Episodes..."
        loadData()
        loadShowView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navBarColor = UIColor(named: "primary")!
        let navBarTextColor = UIColor(named: "pinkish")!
        let tabBarColor = UIColor(named: "primary")!
        
        verifyIfShowIsFavorite()
        
        configureNavigationBar(largeTitleColor: navBarTextColor, backgoundColor: navBarColor, tintColor: navBarTextColor, title: "", preferredLargeTitle: false)
        configTabBar(selectedColor: tabBarColor, unselectedColor: tabBarColor, viewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EpisodeViewController
        if let section = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.row {
            let season = seasons[section]
            let episode = season.episodes[row]
            vc.episode = episode
        }
    }
    
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        show.isFavorite = !show.isFavorite
        updateFavoritesShowsList(show)
        changeFavoriteButtonImage(show.isFavorite)
    }
    
    func verifyIfShowIsFavorite() {
        if DAO.shared.getById(id: Int32(show.id), context: self.context) != nil {
            show.isFavorite = true
            changeFavoriteButtonImage(show.isFavorite)
        } else {
            show.isFavorite = false
            changeFavoriteButtonImage(show.isFavorite)
        }
    }
    
    func updateFavoritesShowsList(_ showToUpdate: Show) {
        if showToUpdate.isFavorite {
            DAO.shared.addShowToFavorites(showToUpdate, context)
        } else {
            DAO.shared.removeShowFromFavorites(showToUpdate, context)
        }
    }
    
    func changeFavoriteButtonImage(_ isFavorite: Bool) {
        DispatchQueue.main.async {
            if isFavorite {
                self.favoriteBarButtonItem.image = UIImage(systemName: "heart.fill")
            } else {
                self.favoriteBarButtonItem.image = UIImage(systemName: "heart")
            }
        }
    }
    
    func loadData() {
        TVmazeAPI.loadSeasons(showId: show.id, onComplete: { (seasons) in
            if let seasons = seasons {
                self.seasons = seasons
                DispatchQueue.main.async {
                    self.label.text = "Could not load episodes!"
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func loadShowView() {
        if let imageUrl = show.image?.original, let url = URL(string: imageUrl) {
            imageShow.kf.setImage(with: url)
        } else {
            imageShow.image = #imageLiteral(resourceName: "logo")
        }
        titleLabel.text = show.name
        scheduleLabel.text = show.schedule?.scheduleAsString ?? "Unavailable"
        genresLabel.text = show.genresAsString
        summaryTextView.attributedText = show.summary?.htmlAttributedString(colorHex: "#FFFFFF")
    }
}

// MARK: - Table view data source
extension ShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView = seasons.count == 0 ? label : nil
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let episodes = seasons[section].episodes
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as! EpisodesTableViewCell
        
        let season = seasons[indexPath.section]
        let episode = season.episodes[indexPath.row]
            
        cell.prepare(with: episode)
        cell.setDisclosureArrow(size: 12.0, color: UIColor(named: "pinkish")!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let season = seasons[section]
        return "Season \(season.number)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}

extension ShowViewController: UITableViewDelegate {
}
