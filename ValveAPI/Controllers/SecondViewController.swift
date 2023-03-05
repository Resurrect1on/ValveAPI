//
//  Second VC.swift
//  ValveAPI
//
//  Created by Dmitry on 03.03.2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var proRoleName: UILabel!
    @IBOutlet weak var proTeamName: UILabel!
    @IBOutlet weak var proSteamName: UILabel!
    @IBOutlet weak var proName: UILabel!
    @IBOutlet weak var proImage: UIImageView!
    
    var name: String?
    var image = [String] ()
    var steamName = [String] ()
    var teamName = [String] ()
    var roleName = [Int] ()
    var pros = [String] ()
    var playerTag: Int?
    
    func selectedPlayer() {
        for i in 0..<pros.count {
            if name == pros[i] {
                playerTag = i
            }
        }
    }
    
 /*  func image (pathURL: String) -> UIImage {
        let url = URL(string:"\(pathURL)")
        var avatar: UIImage = UIImage()
        if let data = try? Data(contentsOf: url!)
        {
            avatar = UIImage(data: data)!
        }
        return avatar
    } */
    
    func mainImage (pathUrl: String) {
        if let url = URL(string: pathUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    let avatar = UIImage(data: imageData)!
                    self.proImage.image = avatar
                }
            } .resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPlayer()
        DispatchQueue.main.async { [self] in
            mainImage(pathUrl: image[playerTag!])
        }
        proName.text = ("Nickname: \(name!)")
        guard playerTag != nil else { return }
        proSteamName.text = ("Steam: \(steamName[playerTag!])")
        proTeamName.text = ("Team: \(teamName[playerTag!])")
        if roleName[playerTag!] == 2 {
            proRoleName.text = "Support"
        }
        else {
            proRoleName.text = "Core Role"
        }
    }
}
