//
//  NoteDeleter.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import Result

class NoteDeleter {
    let note: Note
    let fileManager: FileManager = FileManager.default
    
    init(_ note: Note) {
        self.note = note
    }
    
    func delete() -> Result<Note, NoteDeletionError>  {
        guard fileManager.isDeletableFile(atPath: note.absolutePath()) else {
            return .failure(.noteNotDeletable(note: note))
        }
        
        do {
          try fileManager.removeItem(at: note.localURL)
        } catch {
          return .failure(.deleteFailed(note: note))
        }
        
        return .success(note)
    }
}
