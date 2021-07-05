//
//  ShowsTableViewController.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 15/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class ShowsTableViewController: BaseTableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "pinkish")!
        return label
    }()
    var name: String = ""
    var showsList: [Show] = []
    var loadingShows = false
    var currentPage = 0
    var total = 2000

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Loading Tv Shows..."
        configSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let mainColorView = UIColor(named: "primary")!
        configureNavigationBar(largeTitleColor: UIColor(named: "pinkish")!, backgoundColor: mainColorView, tintColor: mainColorView, title: "Tv Shows", preferredLargeTitle: true)
               loadShows()
        configTabBar(selectedColor: mainColorView, unselectedColor: mainColorView, viewController: self)
        changeSearchBarInputForegroundColor(UIColor(named: "pinkish")!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ShowViewController
        vc.show = showsList[tableView.indexPathForSelectedRow!.row]
        AppReviewManager.standard.increaseScore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configSearchBar() {
        
        let mainSearchBarColor = UIColor(named: "pinkish")!
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = mainSearchBarColor
        searchController.searchBar.barTintColor = mainSearchBarColor
        searchController.searchBar.setupSearchBar(background: .white, inputText: mainSearchBarColor, placeholderText: mainSearchBarColor, image: mainSearchBarColor)
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
    }

    
    // MARK: - Methods for Fetching and Using Data
    func loadShows() {
        loadingShows = true
        TVmazeAPI.loadShows(name: name, page: currentPage) { (shows) in
            if let shows = shows {
                self.showsList = self.name.isEmpty ? self.showsList + shows : shows
                DispatchQueue.main.async {
                    self.loadingShows = false
                    self.label.text = self.name.isEmpty ? "Could not load Tv Shows!" : "Could not find Tv Shows with \(self.name)!"
                    self.tableView.reloadData()
                }
            } else {
                self.label.text = "Error on load Tv Shows!"
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = showsList.count == 0 ? label : nil
        return showsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowsTableViewCell
        
        let show = showsList[indexPath.row]
        cell.prepareCell(with: show)
        cell.setDisclosureArrow(size: 12.0, color: UIColor(named: "pinkish")!)

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == showsList.count - 50 && !loadingShows && showsList.count < total {
            currentPage += 1
            loadShows()
            print("Tamanho da lista: \(showsList.count)")
        }
    }
}

// MARK: - UISearchResultsUpdating and UISearchBarDelegate
extension ShowsTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        name = ""
        currentPage = 0
        showsList = []
        loadShows()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        name = searchBar.text ?? ""
        loadShows()
    }
}
