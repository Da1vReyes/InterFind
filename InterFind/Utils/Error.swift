//
//  Error.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import Foundation

enum LoginError: LocalizedError {
    case invalidCredentials
    case passwordEmpty
    case emailEmpty
    case nameEmpty

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Wrong credentials"
        case .passwordEmpty:
            return "Empty password"
        case .emailEmpty:
            return "Empty email"
        case .nameEmpty:
            return "Empty name"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidCredentials:
            return "The credentials you entered are not valid."
        case .passwordEmpty:
            return "The password field is empty."
        case .emailEmpty:
            return "The email field is empty."
        case .nameEmpty:
            return "The name field is empty."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidCredentials:
            return "Check your credentials and try again."
        case .passwordEmpty:
            return "Enter a password to continue."
        case .emailEmpty:
            return "Enter your email to continue."
        case .nameEmpty:
            return "Enter your name to continue."
        }
    }
}

enum DecoderError: LocalizedError {
    case invalidUserInfo
}

enum LocalStoreError: LocalizedError {
    case invalidCredentials
    case invalidImage
    case emailAlreadyExists

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "The email or password is incorrect."
        case .invalidImage:
            return "The selected image could not be saved."
        case .emailAlreadyExists:
            return "That email is already registered. Log in or use another email."
        }
    }
}
