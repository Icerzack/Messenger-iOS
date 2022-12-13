//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Max Kuznetsov on 03.12.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let data = ["Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var config = UIListContentConfiguration.cell()
            config.text = data[indexPath.row]
            config.textProperties.alignment = .center
            config.textProperties.color = .red
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = data[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ac = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Yes!", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                
                nav.modalPresentationStyle = .fullScreen
                
                strongSelf.present(nav, animated: true)
                
            } catch  {
                print("Failed to log out")
            }
        }))
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(ac,animated: true)
    }
}
