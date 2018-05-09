//
//  Repository.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import SwiftGit2

extension Repository {
    func shortName() -> String? {
        return directoryURL?.lastPathComponent
    }
}
