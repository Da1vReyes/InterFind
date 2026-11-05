//
//  Internship.swift
//  InterFind
//
//  Created by Alex Diaz on 6/11/24.
//

import Foundation

struct InternshipModel: Codable, Hashable {
    
    let id: String
    let companyName: String
    let title: String
    let description: String
    let duration: String
    let location: String
    let requirements: String
    let benefits: String
    let imageUrl: String
    var stipend: String? = nil

    var isFavorite = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case companyName
        case title
        case description
        case duration
        case location
        case requirements
        case benefits
        case imageUrl
        case stipend
    }
}

struct InternshipData: Codable {
    let data: [InternshipModel]
}
