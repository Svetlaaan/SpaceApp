//
//  CoreDataStack.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 22.07.2021.
//

import Foundation
import CoreData

final class CoreDataStack: CoreDataStackProtocol {

    private let container: NSPersistentContainer

    init(modelName: String) {
        let container = NSPersistentContainer(name: modelName)
        self.container = container
    }

    func load() {
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    func deleteAll() {
        let fetchRequest = NSFetchRequest<MOSpacePhoto>(entityName: "MOSpacePhoto")
        backgroundContext.performAndWait {
            let spaceRecords = try? fetchRequest.execute()
            spaceRecords?.forEach {
                backgroundContext.delete($0)
            }
            try? backgroundContext.save()
        }
    }

    var viewContext: NSManagedObjectContext { container.viewContext }
    lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()
    var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
}
