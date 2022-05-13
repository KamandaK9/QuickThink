//
//  DetailViewController.swift
//  QuickThink
//
//  Created by Daniel Senga on 2022/05/12.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var notePad: UITextView!
    var notes = [Note]()
    
    weak var delegate: TableViewDelegate?
    
    var noteTitle: String!
    var noteSubText: String!
    var index: Int!
    var backButtonTapped = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        showNoteText()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if backButtonTapped {
            let wholeNote = notePad.text
            if wholeNote != nil {
                let newlineChars = NSCharacterSet.newlines
                var linesArray = wholeNote!.components(separatedBy: newlineChars).filter{!$0.isEmpty}
                
                guard !linesArray.isEmpty else { return }
                
                if !linesArray[0].isEmpty{
                    noteTitle = linesArray[0]
                    linesArray.removeFirst()
                } else {
                    noteTitle = "New Note"
                }
                
                if linesArray.joined() != "" {
                    noteSubText = linesArray.joined()
                } else {
                    noteSubText = ""
                }
                
                delegate?.saveNote(index: index, noteTitle: noteTitle, note: noteSubText)
            }
        }
        
        
    }
    
    func showNoteText() {
        notePad.text = "\(noteTitle ?? "")\n\(noteSubText ?? "")"
    }
    
    @objc func deleteNote() {
        backButtonTapped = false
        delegate?.deleteNote(index: index)
        navigationController?.popToRootViewController(animated: true)
    }
    
  
    
    func returnHome() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            notePad.contentInset = .zero
        } else {
            notePad.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        notePad.scrollIndicatorInsets = notePad.contentInset

        let selectedRange = notePad.selectedRange
        notePad.scrollRangeToVisible(selectedRange)
    }
    
    
        
        

}
