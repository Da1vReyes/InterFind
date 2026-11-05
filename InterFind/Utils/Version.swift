//
//  Version.swift
//  InterFind
//
//  Created by Alex Diaz on 14/12/24.
//

import Foundation

/// Initializes a `Version` from a semantic version string.
/// - Parameter versionString: A string in the format "major.minor.patch".
/// - Returns: `nil` if the string is not in the correct format.
struct Version {
    
    let major: Int
    let minor: Int
    let patch: Int
    
    init?(versionString: String) {
        let versionComponents = versionString.split(separator: ".")
        guard versionComponents.count == 3,
              let major = Int(versionComponents[0]),
              let minor = Int(versionComponents[1]),
              let patch = Int(versionComponents[2]) else {
            print("Bad format version string")
            return nil
        }
        
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

extension Version: CustomStringConvertible {
    var description: String {
        return "\(major).\(minor).\(patch)"
    }
}

extension Version: Comparable {
    
    static func < (lhs: Version, rhs: Version) -> Bool {
        
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }
        
        return lhs.patch < rhs.patch
    }
    
    static func > (lhs: Version, rhs: Version) -> Bool {
        
        if lhs.major != rhs.major {
            return lhs.major > rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor > rhs.minor
        }
        
        return lhs.patch > rhs.patch
    }
    
    static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
}
