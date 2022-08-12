//
//  NotesViewController.swift
//  Notes App
//
//  Created by Decagon on 11/08/2022.
//

import UIKit
import CoreData

var notes = [Notes]()

class NotesViewController: UIViewController {
    
    var load = true
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    lazy var newNoteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add New Note", for: .normal)
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.frame = view.bounds
        table.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        return table
    }()
    
    @objc func tapBtn() {
        let vc = NewNotesVC()
        navigationController?.pushViewController(vc, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.systemGray6
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemFill
        setupViews()
        setupFetchData()
    }
    
    // MARK: - This function fetches the data saved by coredata
    func setupFetchData() {
        if (load) {
            load = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let requestData = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            do {
                let results: NSArray = try context.fetch(requestData) as NSArray
                for result in results {
                    let note = result as! Notes
                    notes.append(note)
                }
            }
            catch {
                print("failed to fetch data")
            }
        }
    }
    
    func setupViews() {
    view.addSubview(titleLabel)
    view.addSubview(newNoteButton)
    view.addSubview(tableView)
        
    NSLayoutConstraint.activate([
    titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    
    newNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
    newNoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    newNoteButton.heightAnchor.constraint(equalToConstant: 50),
    
    tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
    tableView.bottomAnchor.constraint(equalTo: newNoteButton.bottomAnchor, constant: -50),
    ])
  }
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
        cell.backgroundColor = UIColor.black
        cell.titleLabel.textColor = UIColor.systemGray
        cell.descriptionLabel.textColor = UIColor.systemGray
        let noteText: Notes!
        noteText = notes[indexPath.row]
        
        cell.titleLabel.text = noteText.title
        cell.descriptionLabel.text = noteText.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = notes[indexPath.row]
        let vc = NewNotesVC()
        vc.inputTextField.text = model.title
        vc.descriptionTextView.text = model.desc
        navigationController?.pushViewController(vc, animated: false)
    }
}
