//
//  UserSettingsService.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 23.07.2021.
//

import Foundation

final class UserSettingsService {

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults) {
        self.defaults = userDefaults
    }

    convenience init() {
        self.init(userDefaults: UserDefaults.standard)
    }

    /// Сохранение объекта
    func save<T: Encodable>(object: T, for key: String) {
        guard let data = try? encoder.encode(object) else {
            return
        }
        defaults.setValue(data, forKey: key)
        NSLog("object: \(object) was added for key: \(key)")
    }

    /// Получение объекта по ключу
    func object<T: Decodable>(for key: String) -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        return try? decoder.decode(T.self, from: data)
    }

    /// Удаление объекта по ключу
    func removeObjectForKey(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        NSLog("object for key \(key) removed")
    }
}
