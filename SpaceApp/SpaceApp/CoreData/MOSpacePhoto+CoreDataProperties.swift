//
//  MOSpacePhoto+CoreDataProperties.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 22.07.2021.
//
//

import Foundation
import CoreData


extension MOSpacePhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOSpacePhoto> {
        return NSFetchRequest<MOSpacePhoto>(entityName: "MOSpacePhoto")
    }

    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var explanation: String
    @NSManaged public var date: String
    @NSManaged public var index: Int16
    
}

extension MOSpacePhoto : Identifiable {

}
