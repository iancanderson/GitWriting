//
//  DetailViewController.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/7/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    var noteSaver: NoteSaver!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let note = detailItem {
            self.title = note.name()
            self.noteSaver = NoteSaver.init(note)
            
            if let textView = noteTextView {
                if let fileContents = FileManager.default.contents(atPath: note.absolutePath()) {
                    textView.text = String(data: fileContents, encoding: .utf8)
                    textView.isEditable = true
                    textView.delegate = noteSaver
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Note? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

