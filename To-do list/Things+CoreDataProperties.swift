//
//  Things+CoreDataProperties.swift
//  To-do list
//
//  Created by Julia on 29/08/2022.
//
//

import Foundation
import CoreData


extension Things {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Things> {
        return NSFetchRequest<Things>(entityName: "Things")
    }

    @NSManaged public var title: String?
    @NSManaged public var runTime: Date?
    @NSManaged public var executionStatus: Bool
    @NSManaged public var notes: String?

}
