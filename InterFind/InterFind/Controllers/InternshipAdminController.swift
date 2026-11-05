//
//  InternshipAdminController.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit

class InternshipAdminController {
    
    let codableManager: CodableManager
    var internships: [InternshipModel]
    
    
    init ( codableManager: CodableManager = CodableManager()) {
        
        self.internships = []
        self.codableManager = codableManager
        
    }
    
    func initialize() async {
        await self.getInterships()
    }
    
    func getInterships() async {
        self.internships = await codableManager.parseDataToInternships()
    }
    func getImageData(urlString: String, companyName: String? = nil) async -> UIImage? {
        LocalStore.shared.image(for: urlString, fallbackName: companyName)
    }
    
    func deleteInternship(at index: Int) async {
        LocalStore.shared.deleteInternship(id: internships[index].id)
        self.internships.remove(at: index)
    }
    
    func createInternship(internship: InternshipModel) async -> Bool {
        LocalStore.shared.addInternship(internship)
        self.internships.insert(internship, at: 0)
        return true
    }
}

