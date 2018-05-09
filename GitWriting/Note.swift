//
//  Note.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/7/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import SwiftGit2

struct Note {
    let localURL: URL
    let repo: Repository
    
    func name() -> String {
        return localURL.lastPathComponent
    }
    
    func absolutePath() -> String {
        return localURL.path
    }
}

extension Note: Comparable {
    static func < (lhs: Note, rhs: Note) -> Bool {
        return lhs.absolutePath() < rhs.absolutePath()
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.localURL == rhs.localURL
    }
}
