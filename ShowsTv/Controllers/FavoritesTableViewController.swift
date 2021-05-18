//
//  FavoritesTableViewController.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 15/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var noInfoView: NoInfoView!
    var favoritesShowsList: [ShowCD] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configNoPlacesStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: "secondary")!, tintColor: UIColor(named: "secondary")!, title: "My Favorites", preferredLargeTitle: true)
        configTabBar(selectedColor: UIColor(named: "secondary")!, unselectedColor: UIColor(named: "secondary")!, viewController: self)
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ShowViewController
        let showCD = favoritesShowsList[tableView.indexPathForSelectedRow!.row]
        vc.show = Show.fromShowCD(showCD)
    }
    
    func configNoPlacesStackView() {
        noInfoView = NoInfoView.initializeFromNib()
        noInfoView.config("Loading Favorites...", color: UIColor(named: "secondary")!, image: UIImage(named: "loadingSecondary")!)
    }
    
    func loadData() {
        if let shows: [ShowCD] = DAO.shared.list(with: context) {
            favoritesShowsList = shows
            if shows.count == 0 {
                noInfoView.config("Favorites list is empty!", color: UIColor(named: "secondary")!, image: UIImage(named: "empty")!)
            }
        } else {
            noInfoView.config("Error on loading favorites!", color: UIColor(named: "secondary")!, image: UIImage(named: "error")!)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = favoritesShowsList.count == 0 ? noInfoView : nil
        return favoritesShowsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favShowCell", for: indexPath) as! FavoritesTableViewCell
        
        let showCD = favoritesShowsList[indexPath.row]
        cell.prepareCell(with: Show.fromShowCD(showCD))
        cell.setDisclosureArrow(size: 12.0, color: UIColor(named: "orangish")!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let showCD = favoritesShowsList[indexPath.row]
            favoritesShowsList.remove(at: indexPath.row)
            DAO.shared.removeShowFromFavorites(Show.fromShowCD(showCD), context)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.loadData()
        }
    }

}
