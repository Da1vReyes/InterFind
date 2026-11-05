//
//  CoreDataManager.swift
//  InterFind
//
//  Created by Alex Diaz on 14/11/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let containerName: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: containerName)
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                print("Error loading persistent store: \(error.localizedDescription)")
            }
        }
        
        return persistentContainer
    }()
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    init(containerName: String) {
        self.containerName = containerName
    }
    
    func save() {
        
        guard context.hasChanges else { print("No changes to save") ; return}
        
        do {
            try context.save()
        } catch {
            print("Could not save: \(error.localizedDescription)")
        }
    }
    
    func deleteFavoriteInternship(id: String) {
        let fetchRequest: NSFetchRequest<Internship> = Internship.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
        do {
            
            let internships = try context.fetch(fetchRequest)
            
            if let internshipToDelete = internships.first {
                
                context.delete(internshipToDelete)
                save()
                
                print("Item deleted")
            } else {
                print("No object found with id: \(id)")
            }
        } catch {
            print("Could not delete the object: \(error.localizedDescription)")
        }
    }
    
    func getFavoriteInternships() -> [NSManagedObject] {
        let fetchRequest = Internship.fetchRequest()
        
        do {
            let internships = try context.fetch(fetchRequest)
            return internships
        } catch {
            print("Could not load saved internships: \(error.localizedDescription)")
        }
        return []
    }
}
