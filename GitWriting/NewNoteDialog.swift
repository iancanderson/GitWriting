//
//  NewNoteDialog.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/9/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import Foundation
import UIKit

struct NewNoteDialog {
    let alertController: UIAlertController
    
    init(createHandler: @escaping ((String?) -> Void)) {
        self.alertController = UIAlertController(title: "New Note", message: "Enter note name", preferredStyle: .alert)
        let defaultNoteName = self.defaultNoteName()

        alertController.addTextField { (textField) in
            textField.text = defaultNoteName
        }
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alertController] (_) in
            let text = alertController?.textFields![0].text
            createHandler(text)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    func present(controller: UIViewController) {
        controller.present(alertController, animated: true, completion: nil)
    }
    
    private func defaultNoteName() -> String {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let iso8601String = dateFormatter.string(from: Date())
        return "\(iso8601String)-new-note"
    }
}
