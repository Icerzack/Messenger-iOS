//
//  ViewController.swift
//  Messenger
//
//  Created by Max Kuznetsov on 03.12.2022.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        validateAuth()
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}

