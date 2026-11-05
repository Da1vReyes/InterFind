//
//  Constants.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import Foundation

enum Constants {
    /// Servicio usado para guardar la sesión en el Keychain.
    static let keychainService = "InterFind.session"
    /// Archivo JSON con las pasantías de ejemplo incluido en la app.
    static let seedFileName = "internships"
    /// Nombre del modelo de Core Data.
    static let coreDataContainer = "InterFind"

    /// Cuenta demo incluida en la app (también es la cuenta administradora).
    enum DemoAccount {
        static let name = "Daiv"
        static let email = "daiv@interfind.app"
        static let password = "interfind"
    }

    /// Clave para recordar que el onboarding ya se vio.
    static let hasSeenOnboardingKey = "hasSeenOnboarding"
}
