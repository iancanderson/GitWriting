//
//  NoteCreationError.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation

enum NoteCreationError: Error {
    case noRepoDirectory
    case noteAlreadyExists(name: String)
}

extension NoteCreationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noRepoDirectory:
            return "The repo's local directory does not exist"
        case .noteAlreadyExists(name: let name):
            return "Note \(name) already exists"
        }
    }
}
