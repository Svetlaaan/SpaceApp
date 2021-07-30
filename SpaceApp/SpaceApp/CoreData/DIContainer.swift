//
//  DIContainer.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 22.07.2021.
//

import Foundation

/// ServiceLocator
final class Container {
    /// Singleton
    static let shared = Container()
    /// Инициализатор  скрыт, чтобы предотвратить
    /// прямое создание объекта через инициализатор.
    private init() {}

    lazy var coreDataStack = CoreDataStack(modelName: "SpaceApp")
}
