//
//  LoginResponse.swift
//  InterFind
//
//  Created by Alex Diaz on 9/11/24.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let user: User
}
