//
//  NoteSaver.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import UIKit

class NoteSaver : NSObject, UITextViewDelegate {
    let note: Note
    var contents: String = ""
    
    init(_ note: Note) {
        self.note = note
        super.init()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let oldContents = contents
        if let newContents = textView.text {
            print("Note contents changed from \(oldContents) to \(newContents)")
            self.contents = newContents
            updateFileContents()
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
}
