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
        if let localURL = buildLocalURL(), let repo = getLocalRepo() {
            print("successfully got local repo")
            switch repo.HEAD() {
            case let .success(ref):
                print("HEAD at \(ref)")
            case let .failure(error):
                print("failed to get HEAD ref: \(error)")
            }
            
            do {
                let files = try fileManager.contentsOfDirectory(at: localURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                return files.map { Note(localURL: $0) }.sorted()
            } catch {
                print(error)
            }
        }
        
        return []
    }
    
    private func getLocalRepo() -> Repository? {
        guard let localURL = buildLocalURL() else {
            print("failed to build local URL")
            return nil
        }
        
        if(repoIsCloned()) {
            // If we already have cloned a repo with this remote, just load that repo from disk
            //TODO: pull latest changes from remote?
            print("repo is already cloned")
            switch Repository.at(localURL) {
            case let .success(repo):
                print(repo)
                return repo
            case let .failure(error):
                print(error)
            }
        } else {
            // Else, clone the repo from the remote url
            do {
                try fileManager.createDirectory(at: localURL, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                print(error)
            }
            
            switch Repository.clone(from: remoteURL, to: localURL) {
            case let .success(repo):
                print(repo)
                return repo
            case let .failure(error):
                print(error)
            }
        }
        
        return nil
    }
    
    private func repoIsCloned() -> Bool {
        if let clonePath = buildLocalURL()?.path {
            return fileManager.fileExists(atPath: clonePath)
        } else {
            return false;
        }
    }
    
    // For https://github.com/iancanderson/notes-test, returns file:///:documents_directory/github.com/iancanderson/notes-test
    private func buildLocalURL() -> URL? {
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
