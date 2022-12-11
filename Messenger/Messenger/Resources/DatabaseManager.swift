//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Max Kuznetsov on 10.12.2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://messenger-9e83c-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
}

struct ChatUser{
    let firstName: String
    let lastName: String
    let emailAddress: String
    //let profilePicture: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

//MARK: Account management
extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool)->(Void))){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard let _ = snapshot.value as? String else {
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    ///Inserts new user into the Database
    public func insertUser(user: ChatUser) {
        database.child(user.safeEmail).setValue([
            "first-name": user.firstName,
            "last-name": user.lastName
        ])
    }
}
