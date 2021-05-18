//
//  PersonViewController.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 18/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "secondary")!
        return label
    }()
    var shows: [Show] = []
    var person: Person!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Loading Tv Shows..."
        loadData()
        loadPersonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navBarColor = UIColor(named: "secondary")!
        let navBarTextColor: UIColor = .white
        let tabBarColor = UIColor(named: "secondary")!
        
        configureNavigationBar(largeTitleColor: navBarTextColor, backgoundColor: navBarColor, tintColor: navBarTextColor, title: "", preferredLargeTitle: false)
        configTabBar(selectedColor: tabBarColor, unselectedColor: tabBarColor, viewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ShowViewController
        if let row = tableView.indexPathForSelectedRow?.row {
            let show = shows[row]
            vc.show = show
        }
    }
    
    func loadPersonView() {
        if let imageUrl = person.image?.original, let url = URL(string: imageUrl) {
            imagePerson.kf.setImage(with: url)
        } else {
            imagePerson.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "orangish")!)
        }
        
        imagePerson.layer.cornerRadius = imagePerson.frame.height/2
        imagePerson.layer.borderColor = UIColor(named: "secondary")!.cgColor
        imagePerson.layer.borderWidth = 6
        
        titleLabel.text = person.name
    }
    
    func loadData() {
        TVmazeAPI.loadShowsFromCastcredits(person.id) { (shows) in
            if let shows = shows {
                self.shows = shows
                DispatchQueue.main.async {
                    self.label.text = "Could not find TV shows for that person!"
                    self.tableView.reloadData()
                }
            } else {
                self.label.text = "Error on loading Tv Shows for this person!"
            }
        }
    }

}

// MARK: - Table view data source
extension PersonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = shows.count == 0 ? label : nil
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "castcreditsCell", for: indexPath) as! CastcreditsTableViewCell
        
        let show = shows[indexPath.row]
            
        cell.prepareCell(with: show)
        cell.setDisclosureArrow(size: 12.0, color: UIColor(named: "secondary")!)
        
        return cell
    }
}

extension PersonViewController: UITableViewDelegate {
}
