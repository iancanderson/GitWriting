//
//  NotesLoader.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/7/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import SwiftGit2

class NotesLoader {
    let repo: Repository
    let fileManager = FileManager.default
    
    init(repo: Repository) {
        self.repo = repo
    }
    
    func loadNotes() -> [Note] {
        if let localURL = repo.directoryURL {
            do {
                let files = try fileManager.contentsOfDirectory(at: localURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                return files.map { Note(localURL: $0) }.sorted()
            } catch {
                print(error)
            }
        }
        
        return []
    }
}
