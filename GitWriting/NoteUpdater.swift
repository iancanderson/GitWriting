//
//  NoteUpdater.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import UIKit

let secondsBetweenAutoSaveCommits: TimeInterval = 10

class NoteUpdater : NSObject, UITextViewDelegate {
    let note: Note
    var contents: String = ""
    var lastCommittedChanges: Date? = nil
    var commitTimer: Timer? = nil
    
    init(_ note: Note) {
        self.note = note
        super.init()
        
        self.commitTimer = Timer.scheduledTimer(timeInterval: secondsBetweenAutoSaveCommits, target: self, selector: #selector(NoteUpdater.commitChanges), userInfo: nil, repeats: true)
        commitTimer?.tolerance = 1 // okay if the timer executes up to 1 second later than scheduled
    }
    
    deinit {
        commitTimer?.invalidate()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let oldContents = contents
        if let newContents = textView.text {
            if (newContents != oldContents) {
                self.contents = newContents
                updateFileContents()
            }
        }
    }
    
    // Re-write the file on disk with the new contents
    private func updateFileContents() {
        do {
            try contents.write(to: note.localURL, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    @objc
    private func commitChanges() {
        // If there are changes, commit them
        // Else, do nothing
        guard hasUncommittedChanges() else {
            print("No changes to commit")
            return
        }

        // Add all files and commit
        let repo = note.repo
        let commitResult = repo.add(path: ".").flatMap {
            repo.commit(message: "auto saving notes", signature: .init(name: "my name", email: "my email"))
        }
        switch commitResult {
        case let .success(commit):
            print("autosaved commit \(commit)")
        case let .failure(error):
            print("failed to autosave: \(error)")
        }
    }
        
    private func hasUncommittedChanges() -> Bool {
        let repo = note.repo
        switch repo.status() {
        case let .success(statusEntries):
            return !statusEntries.isEmpty
        case let .failure(error):
            print(error)
            return false
        }
    }
}
