//
//  MasterViewController.swift
//  GitWriting
//
//  Created by Ian Anderson on 5/7/18.
//  Copyright © 2018 Ian Anderson. All rights reserved.
//

import KeychainAccess
import Result
import SwiftGit2
import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var notes = [Note]()
    var repo : Repository? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // TODO - ask user for credentials and set them here
//        GitHubCredentials.set(username: "iancanderson", password: "foobar")
        
        let repoURL = URL(string: "https://github.com/iancanderson/notes-test")!
        self.repo = RepoLoader.init(remoteURL: repoURL).loadRepo()
        
        if let repo = repo {
            self.title = repo.shortName()
            self.notes = NotesLoader.init(repo: repo).loadNotes()
        }
        
        dump(notes)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func newNote(_ sender: Any) {
        if let repo = repo {
            let dialog = NewNoteDialog.init(createHandler: { (name: String?) in
                //TODO: how to handle empty note name?
                let name = name ?? "new-note"
                
                switch NoteCreator.init(name: name, repo: repo).create() {
                case let .success(note):
                    self.notes.insert(note, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    // Select row so it will be passed to detail controller during segue
                    self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    self.performSegue(withIdentifier: "showDetail", sender: self)
                case let .failure(error):
                    self.showError(error)
                }
            })
            
            dialog.present(controller: self)
        }
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = notes[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = notes[indexPath.row]
        cell.textLabel!.text = object.name()
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            switch NoteDeleter.init(note).delete() {
            case .success:
                notes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            case let .failure(error):
                showError(error)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

