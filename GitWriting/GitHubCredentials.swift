//
//  GitHubCredentials.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/10/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import KeychainAccess
import SwiftGit2

class GitHubCredentials {
    static let keychain = Keychain(server: "https://github.com", protocolType: .https)
    
    static func set(username: String, password: String) {
        do {
            try keychain.set(username, key: "username")
            try keychain.set(password, key: "password")
        } catch {
            print("Error saving credentials to keychain: \(error)")
        }
    }
    
    static func get() -> Credentials? {
        do {
            let username = try keychain.get("username")
            let password = try keychain.get("password")
            if let username = username, let password = password {
                return Credentials.plaintext(username: username, password: password)
            }
        } catch {
            print("Error fetching credentials from keychain")
        }
        
        return nil
    }
}
