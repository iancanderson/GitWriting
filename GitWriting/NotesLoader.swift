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
    let remoteURL: URL
    let fileManager = FileManager.default
    
    init(remoteURL: URL) {
        self.remoteURL = remoteURL
    }
    
    func loadNotes() -> [Note] {
        if(repoIsCloned()) {
            // If we already have cloned a repo with this remote, just load that repo from disk
            print("repo is already cloned")
        } else {
            // Else, clone the repo from the remote url
            if let localURL = localURL() {
                do {
                    try fileManager.createDirectory(at: localURL, withIntermediateDirectories: true, attributes: nil)

                } catch {
                    print(error)
                }
                
                switch Repository.clone(from: remoteURL, to: localURL) {
                case let .success(repo):
                    print(repo)
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        return [Note(name: "hi")]
    }
    
    private func repoIsCloned() -> Bool {
        if let clonePath = localURL()?.path {
            return fileManager.fileExists(atPath: clonePath)
        } else {
            return false;
        }
    }
    
    // For https://github.com/iancanderson/notes-test, returns file:///:documents_directory/github.com/iancanderson/notes-test
    private func localURL() -> URL? {
        do {
            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            if let host = remoteURL.host {
                let subdomainPath = host + remoteURL.path
                return URL(fileURLWithPath: subdomainPath, relativeTo: documentDirectoryURL)
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
