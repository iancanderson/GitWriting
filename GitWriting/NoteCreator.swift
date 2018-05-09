//
//  NoteCreator.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import Result
import SwiftGit2

class NoteCreator {
    let name: String
    let repo: Repository
    let fileManager: FileManager = FileManager.default
    
    init(name: String, repo: Repository) {
        self.name = name
        self.repo = repo
    }
    
    func create() -> Result<Note, NoteCreationError>  {
        guard let url = localURL() else {
            return .failure(.noRepoDirectory)
        }
        
        if fileManager.fileExists(atPath: url.path) {
            return .failure(.noteAlreadyExists(name: url.lastPathComponent))
        }
        
        // Create a file in the repo's directory
        let emptyContents = "".data(using: .utf8)
        fileManager.createFile(atPath: url.path, contents: emptyContents)
        
        // Add file to git index
        repo.addAll()
        
        return .success(Note(localURL: url, repo: repo))
    }
    
    private func localURL() -> URL? {
        return repo.directoryURL?.appendingPathComponent(nameWithExtension())
    }
    
    private func nameWithExtension() -> String {
        return "\(name).md"
    }
}
