//
//  Internship+CoreDataProperties.swift
//  InterFind
//
//  Created by Alex Diaz on 27/11/24.
//
//

import Foundation
import CoreData


extension Internship {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Internship> {
        return NSFetchRequest<Internship>(entityName: "Internship")
    }

    @NSManaged public var benefits: String?
    @NSManaged public var companyName: String?
    @NSManaged public var descriptionObject: String?
    @NSManaged public var duration: String?
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var location: String?
    @NSManaged public var requirements: String?
    @NSManaged public var title: String?

}

extension Internship : Identifiable {

}
