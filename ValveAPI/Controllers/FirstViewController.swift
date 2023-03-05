//
//  ViewController.swift
//  ValveAPI
//
//  Created by Dmitry on 02.03.2023.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData = [String] ()
    var isSearching = false
    var selectedName: String?
    var proNames = [String] ()
    var proAvatars = [String] ()
    var proSteam = [String] ()
    var proTeams = [String] ()
    var proRoles = [Int] ()
    
    func names(completion: @escaping ([String]) -> Void) {
        ApiManager.shared.getInformation { players in
            completion(players.map{$0.name!})
        }
    }
    func avatars(completion: @escaping ([String]) -> Void) {
        ApiManager.shared.getInformation { players in
            completion(players.map{$0.avatarfull!})
        }
    }
    func steam(completion: @escaping ([String]) -> Void) {
        ApiManager.shared.getInformation { players in
            completion(players.map{$0.personaname!})
        }
    }
    func teams(completion: @escaping ([String]) -> Void) {
        ApiManager.shared.getInformation { players in
            completion(players.map{$0.teamName ?? ""})
        }
    }
    func roles(completion: @escaping ([Int]) -> Void) {
        ApiManager.shared.getInformation { players in
            completion(players.map{$0.fantasyRole!})
        }
    }
    
    @IBAction func touch(_ sender: UIButton) {
        if let indexPath = table.indexPath(for: sender.superview!.superview as! UITableViewCell) {
            let cell = table.cellForRow(at: indexPath)
            selectedName = cell?.textLabel?.text
            performSegue(withIdentifier: "segue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.table.dataSource =   self
        
        names() { names in
            self.proNames = names
        }
        avatars() { avatars in
            self.proAvatars = avatars
        }
        steam() { steam in
            self.proSteam = steam
        }
        teams() { teams in
            self.proTeams = teams
        }
        roles() { roles in
            self.proRoles = roles
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc2 = segue.destination as? SecondViewController else { return }
        vc2.name = selectedName
        vc2.pros = proNames
        vc2.image = proAvatars
        vc2.steamName = proSteam
        vc2.teamName = proTeams
        vc2.roleName = proRoles
    }
}

extension FirstViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredData.removeAll()
        guard searchText != "" || searchText != " " else {
            return
        }
        for item in proNames {
            let text = searchText.lowercased()
            let namesText = item.lowercased().range(of: text)
            if namesText != nil {
                filteredData.append(item)
            }
        }
        // print(filteredData)
        
        if searchBar.text == "" {
            isSearching = false
            table.reloadData()
        }
        else {
            isSearching = true
            let searchBarText = searchBar.text?.lowercased()
            filteredData = proNames.filter({$0.lowercased().contains(searchBarText ?? "")})
            table.reloadData()
        }
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        else {
            return proNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearching {
            cell.textLabel?.text = filteredData[indexPath.row]
        }
        else {
            cell.textLabel?.text = proNames[indexPath.row]
        }
        return cell
    }
}
