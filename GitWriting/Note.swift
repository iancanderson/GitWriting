//
//  Note.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/7/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation

struct Note: Equatable {
    let name: String
}

extension Note: Comparable {
    static func < (lhs: Note, rhs: Note) -> Bool {
        return lhs.name < rhs.name
    }
}
