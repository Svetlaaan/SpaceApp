//
//  UserSettings.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 23.07.2021.
//

import Foundation

final class UserSettings {
    
    private enum SettingKeys: String {
        case userName
    }
    
    static var userName: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingKeys.userName.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKeys.userName.rawValue
            if let name = newValue {
                print("value: \(name) was added to SettingKeys.\(key)")
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
