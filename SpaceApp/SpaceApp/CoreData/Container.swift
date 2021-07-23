//
//  Container.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 22.07.2021.
//

import Foundation

// это просто ServiceLocator

final class Container {
    static let shared = Container()
    private init() {}

    lazy var coreDataStack = CoreDataStack(modelName: "SpaceApp")
}
