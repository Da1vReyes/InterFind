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
            return "Credenciales incorrectas"
        case .passwordEmpty:
            return "Contraseña vacía"
        case .emailEmpty:
            return "Email vacío"
        case .nameEmpty:
            return "Nombre vacío"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidCredentials:
            return "Las credenciales proporcionadas no son válidas."
        case .passwordEmpty:
            return "No se ingresó una contraseña en el campo correspondiente."
        case .emailEmpty:
            return "No se ingresó un email en el campo correspondiente."
        case .nameEmpty:
            return "No se ingresó un nombre en el campo correspondiente."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidCredentials:
            return "Verifica tus credenciales e inténtalo nuevamente."
        case .passwordEmpty:
            return "Ingresa una contraseña antes de continuar."
        case .emailEmpty:
            return "Ingresa un email antes de continuar."
        case .nameEmpty:
            return "Ingresa un nombre antes de continuar."
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
            return "El correo o la contraseña no son correctos."
        case .invalidImage:
            return "No se pudo guardar la imagen seleccionada."
        case .emailAlreadyExists:
            return "Ese correo ya está registrado. Inicia sesión o usa otro correo."
        }
    }
}
