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
    
    func pushToOrigin() {
        guard let localBranch = HEAD().value as? Branch else {
            print("Can't push - not on a branch")
            return
        }
        guard let remoteBranch = remoteBranch(named: "origin/master").value else {
            print("Can't push - no remote branch with name origin/master")
            return
        }
        guard let credentials = GitHubCredentials.get() else {
            return
        }
        
        let pushResult = remote(named: "origin").flatMap {
            push(remote: $0, branch: localBranch, credentials: credentials)
        }
        
        switch pushResult {
        case .success:
            print("Push to origin succeeded")
        case let .failure(error):
            print("Push failed: \(error)")
        }
    }
}
