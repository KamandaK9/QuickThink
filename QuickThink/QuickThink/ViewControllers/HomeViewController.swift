//
//  HomeViewController.swift
//  QuickThink
//
//  Created by Daniel Senga on 2022/05/12.
//

import UIKit

protocol TableViewDelegate: AnyObject {
    func saveNote(index:Int, noteTitle: String, note: String)
    func deleteNote(index: Int)
}

class HomeViewController: UITableViewController {
    var notes = [Note]() {
        didSet {
            tableView.reloadData()
            save()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

      title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(composeNote))
        tableView.reloadData()
        loadSaved()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notes = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.text = notes.name
        cell.detailTextLabel?.text = notes.note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notes = notes[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "textpadController") as? DetailViewController {
            vc.index = 0
            vc.delegate = self
            
            vc.index = indexPath.row
            vc.noteTitle = notes.name
            vc.noteSubText = notes.note
            vc.backButtonTapped = true
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
           
        }
    }
    
    @objc func composeNote() {
        let newNote = Note(name: "New Note", note: "")
        notes.insert(newNote, at: 0)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "textpadController") as? DetailViewController {
            vc.index = 0
            vc.delegate = self
            vc.backButtonTapped = true
            
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save notes")
        }
    }
    
    func loadSaved() {
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
                
            } catch {
                print(error)
            }
        }
    }


}

extension HomeViewController: TableViewDelegate {
    func deleteNote(index: Int) {
        notes.remove(at: index)
    }
    
    func saveNote(index:Int, noteTitle: String, note: String) {
        notes[index] = Note(name: noteTitle, note: note)
        tableView.reloadData()
        save()
    }
}
