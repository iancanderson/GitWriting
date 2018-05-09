//
//  NoteDeletionError.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation

enum NoteDeletionError: Error {
    case noteNotDeletable(note: Note)
    case deleteFailed(note: Note)
}

extension NoteDeletionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noteNotDeletable(note: let note):
            return "Note \(note.name()) not deletable"
        case .deleteFailed(note: let note):
            return "Note \(note.name()) failed to be removed"
        }
    }
}
