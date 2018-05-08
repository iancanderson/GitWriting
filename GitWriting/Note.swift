//
//  Note.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/7/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation

struct Note: Equatable {
    let localURL: URL
    
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
