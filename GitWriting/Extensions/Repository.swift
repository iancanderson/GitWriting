//
//  Repository.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import Result
import SwiftGit2

let gitAuthor = Signature.init(name: "Git Writing", email: "gitwriting@example.com")

extension Repository {
    func shortName() -> String? {
        return directoryURL?.lastPathComponent
    }
    
    func addAllAndCommit(message: String) -> Result<Commit, NSError> {
        return addAll().flatMap {
            commit(message: message, signature: gitAuthor)
        }
    }
    
    // Stages all files
    func addAll() -> Result<(), NSError> {
        return add(path: ".")
    }
}
