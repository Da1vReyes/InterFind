//
//  HomeController.swift
//  InterFind
//
//  Created by Alex Diaz on 5/11/24.
//

import UIKit
import CoreData

class HomeController {
    
    let codableManager: CodableManager
    let user: User
    let adsImageData: [AdsData?]
    var internships: [InternshipModel]
    var coreDataManager: CoreDataManager
    var favoriteInternships: [Internship]!
    
    
    init(adsImageData: [AdsData?], codableManager: CodableManager = CodableManager(), coreDataManager: CoreDataManager = CoreDataManager(containerName: Constants.coreDataContainer)) {
        
        self.adsImageData = adsImageData
        self.internships = []
        self.codableManager = codableManager
        self.user = LoginController.getUser() ?? User(id: "guest", name: "Invitado", email: "")
        self.coreDataManager = coreDataManager
        self.getFavoriteInternships()
        
    }
    
    func initialize() async {
        await self.getInterships()
        self.matchFavoriteInternships()
    }
    
    func getInterships() async {
        self.internships = await codableManager.parseDataToInternships()
    }
    
    func getImageData(urlString: String, companyName: String? = nil) async -> UIImage? {
        LocalStore.shared.image(for: urlString, fallbackName: companyName)
    }
    
    func getFavoriteInternships() {
        self.favoriteInternships = coreDataManager.getFavoriteInternships() as? [Internship]
    }
    
    func matchFavoriteInternships() {
        guard !favoriteInternships.isEmpty else { return }
        let favoriteIDs: Set<String> = Set(
            self.favoriteInternships.compactMap({ favorite in
                favorite.value(forKey: "id") as? String
            })
        )
        let length = self.favoriteInternships.count
        var counter: Int = 0
        
        for (index, internship) in self.internships.enumerated() {
            if favoriteIDs.contains(internship.id) {
                self.internships[index].isFavorite = true
                counter += 1
            }
            if counter == length { break }
        }
    }
    
    func saveInternshipAsFavorite(internship: InternshipModel) {
        
        let newInternship = Internship(context: coreDataManager.context)
        newInternship.title = internship.title
        newInternship.benefits = internship.benefits
        newInternship.descriptionObject = internship.description
        newInternship.imageUrl = internship.imageUrl
        newInternship.location = internship.location
        newInternship.companyName = internship.companyName
        newInternship.id = internship.id
        newInternship.isFavorite = internship.isFavorite
        newInternship.requirements = internship.requirements
        newInternship.duration = internship.duration
        
        coreDataManager.save()
        getFavoriteInternships()
    }
    
    func deleteInternshipFromFavorite(internship: InternshipModel) {
        coreDataManager.deleteFavoriteInternship(id: internship.id)
        getFavoriteInternships()
    }
    
}

