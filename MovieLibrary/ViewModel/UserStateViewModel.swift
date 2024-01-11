//
//  UserStateViewModel.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 07/01/24.
//

import Foundation
import SwiftUI

class UserStateViewModel: ObservableObject {
    let userDefault = UserDefaults.standard
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    func getUidAndToken() -> (String?, String?) {
        let uid = userDefault.value(forKey: Constants.uid) as? String
        let token = userDefault.value(forKey: Constants.token) as? String
        return (uid, token)
    }
    
    func getUsername() -> String? {
        let name = userDefault.value(forKey: Constants.name) as? String
        return name
    }
    
    func saveUid(_ uid :UUID?, token: String?, name: String?) {
        userDefault.set(uid?.uuidString, forKey: Constants.uid)
        userDefault.set(token, forKey: Constants.token)
        userDefault.set(name, forKey: Constants.name)
        isLoggedIn = true
    }
    
    func removeUidAndToken() {
        userDefault.set(nil, forKey: Constants.uid)
        userDefault.set(nil, forKey: Constants.token)
        userDefault.set(nil, forKey: Constants.name)
        isLoggedIn = false
    }
}
