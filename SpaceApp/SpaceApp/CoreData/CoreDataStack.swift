//
//  CoreDataStack.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 22.07.2021.
//

// coordinator - отвечает за сохранение obj model
// контекст - в нем определенный координатор. На один координатор одна object model.

import Foundation
import CoreData

final class CoreDataStack {

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

    func fetchMaxIndex() {
        // класс NSFetchRequest используется в качестве запроса выборки данных из модели.
        // Этот инструмент позволяет задавать правила фильтрации и сортировки объектов на
        // этапе извлечения их из базы данных
        let fetchRequest = NSFetchRequest<MOSpacePhoto>(entityName: "MOSpacePhoto")

        let indexSortDescriptor = NSSortDescriptor(key: "index", ascending: false)
        fetchRequest.sortDescriptors = [indexSortDescriptor]
        fetchRequest.fetchLimit = 1
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "MOSpacePhoto", in: backgroundContext)
        let results = try? backgroundContext.fetch(fetchRequest) as [MOSpacePhoto]
        let firstResult = results?.first
        guard let result = firstResult else { return }
        if let title = result.value(forKey: "title") as? String, let index = result.value(forKey: "index") as? Int {
            debugPrint("max index - \(index) title - \(title)")
        }
    }

    var viewContext: NSManagedObjectContext { container.viewContext }
    lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()
    var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
}
