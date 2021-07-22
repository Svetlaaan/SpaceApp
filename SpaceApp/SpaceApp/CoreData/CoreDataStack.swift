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
		container.loadPersistentStores { desc, error in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
		}
	}

	func deleteAll() {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MOSpacePhoto")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
		try? coordinator.execute(deleteRequest, with: backgroundContext)
	}

	var viewContext: NSManagedObjectContext { container.viewContext }
	lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()
	var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
}
