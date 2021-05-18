//
//  PeopleTableViewController.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 18/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var noInfoView: NoInfoView!
    var name: String = ""
    var peopleList: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchBar()
        configNoPlacesStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let mainColorView = UIColor(named: "orangish")!
        configureNavigationBar(largeTitleColor: .white, backgoundColor: mainColorView, tintColor: mainColorView, title: "Search People", preferredLargeTitle: true)
        configTabBar(selectedColor: mainColorView, unselectedColor: mainColorView, viewController: self)
        changeSearchBarInputForegroundColor(UIColor(named: "secondary")!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PersonViewController
        vc.person = peopleList[tableView.indexPathForSelectedRow!.row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configSearchBar() {
        
        let mainSearchBarColor = UIColor(named: "secondary")!
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = mainSearchBarColor
        searchController.searchBar.barTintColor = mainSearchBarColor
        searchController.searchBar.setupSearchBar(background: .white, inputText: mainSearchBarColor, placeholderText: mainSearchBarColor, image: mainSearchBarColor)
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
    }


    func configNoPlacesStackView() {
        noInfoView = NoInfoView.initializeFromNib()
        noInfoView.config("Find people from Tv Shows...", color: UIColor(named: "orangish")!, image: UIImage(named: "search")!)
    }
        
    // MARK: - Methods for Fetching and Using Data
    func loadPeople() {
        TVmazeAPI.loadPeople(name: name) { (people) in
            if let people = people {
                self.peopleList = self.name.isEmpty ? [] : people
                DispatchQueue.main.async {
                    if self.name.isEmpty {
                        self.noInfoView.config("Find people from Tv Shows...", color: UIColor(named: "orangish")!, image: UIImage(named: "search")!)
                    } else {
                        self.noInfoView.config("Could not find people with \(self.name)!", color: UIColor(named: "secondary")!, image: UIImage(named: "error")!)
                    }
                    self.tableView.reloadData()
                }
            } else {
                self.noInfoView.config("Error on load people!", color: UIColor(named: "secondary")!, image: UIImage(named: "error")!)
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = peopleList.count == 0 ? noInfoView : nil
        return peopleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell
        
        let person = peopleList[indexPath.row]
        cell.prepareCell(with: person)
        cell.setDisclosureArrow(size: 12.0, color: UIColor(named: "secondary")!)

        return cell
    }
}

// MARK: - UISearchResultsUpdating and UISearchBarDelegate
extension PeopleTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        name = ""
        peopleList = []
        DispatchQueue.main.async {
            self.noInfoView.config("Find people from Tv Shows...", color: UIColor(named: "orangish")!, image: UIImage(named: "search")!)
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        name = searchBar.text ?? ""
        loadPeople()
    }
}
