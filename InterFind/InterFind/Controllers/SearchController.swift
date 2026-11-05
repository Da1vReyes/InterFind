//
//  SearchController.swift
//  InterFind
//
//  Created by Alex Diaz on 29/11/24.
//

import Foundation

class SearchController {
    
    var filteredInternships: [InternshipModel] = []
    
    func filterInternships(with query: String, internships: [InternshipModel]) {
        
        self.filteredInternships = internships.filter {
            $0.companyName.lowercased().contains(query.lowercased())
            || $0.title.lowercased().contains(query.lowercased())
            || $0.benefits.lowercased().contains(query.lowercased())
        }
    }
}
