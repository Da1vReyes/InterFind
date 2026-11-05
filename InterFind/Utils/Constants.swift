//
//  Constants.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import Foundation

enum Constants {
    /// Keychain service used to store the session.
    static let keychainService = "InterFind.session"
    /// Bundled JSON file with the sample internships.
    static let seedFileName = "internships"
    /// Bump when internships.json changes so existing installs pick up the new sample data.
    static let seedVersion = 2
    /// Core Data model name.
    static let coreDataContainer = "InterFind"

    /// Demo account bundled with the app (also the admin account).
    enum DemoAccount {
        static let name = "Daiv"
        static let email = "daiv@interfind.app"
        static let password = "interfind"
    }

    /// Remembers that onboarding was already shown.
    static let hasSeenOnboardingKey = "hasSeenOnboarding"
}
