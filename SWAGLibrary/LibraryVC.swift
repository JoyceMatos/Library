//
//  ViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Look through all files and seperate view & model functionality from VC
// TODO: - Consider using delegation as opposed to NotificationCenter
// TODO: - Change alpha when removing an item
// TODO: - Add instructions: Swipe to delete or edit
// TODO: - If there is nothing to delete, tell user 
// TODO: - Look over file organization ie: Error, Alert, etc
// TODO: - Should VC's be final?


class LibraryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteLibraryButton: UIButton!
    @IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    let refresher = UIRefreshControl()
    
    let client = LibraryAPIClient.sharedInstance
    let store = LibraryDataStore.sharedInstance
    var alertDelegate: AlertDelegate?
    var errorHandler: ErrorHandling?
    var didDisplayOptions = false
    
    // MARK: - View Lifecyle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attach these in storyboard?
        tableView.delegate = self
        tableView.dataSource = self
        alertDelegate = self
        errorHandler = self
        
        fetch()
        observe()
        refresh()
        hideMenuButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureEmptyState()
    }
    
    
    // MARK: - Refresh Methods
    
    func refresh() {
        if #available (iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        refresher.addTarget(self, action: #selector(refreshView), for: .valueChanged)
    }
    
    func refreshView() {
        fetch()
        refresher.endRefreshing()
    }
    
    // MARK: - Observe Methods
    
    // TODO: - Protocol for observing/reloading/refreshing
    func observe() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVC(notification:)), name: .update, object: nil)
    }
    
    func reloadVC(notification: NSNotification) {
        fetch()
    }
    
    // MARK: - View Methods
    
    func showMenuButtons() {
        didDisplayOptions = true
        deleteLibraryButton.isHidden = false
        addBookButton.isHidden = false
        // TODO: - Animate menu button state
    }
    
    func hideMenuButtons() {
        didDisplayOptions = false
        deleteLibraryButton.isHidden = true
        addBookButton.isHidden = true
        // TODO: - Animate menu button state
        
    }
    
    func validateButtonStatus() {
        switch didDisplayOptions {
        case false:
            showMenuButtons()
        case true:
            hideMenuButtons()
        }
    }
    
    // Create custom struct view for this to seperate view logic
    func configureEmptyState() {
        if tableView(tableView, numberOfRowsInSection: 1) == 0 {
            // Constrain
            let emptyStateLabel = UILabel(frame: tableView.frame)
            emptyStateLabel.text = "Click '+' to add a book"
            emptyStateLabel.textAlignment = .center
            emptyStateLabel.textColor = UIColor.darkGray
            emptyStateLabel.font = UIFont(name: "Avenir", size: 20)
            tableView.backgroundView = emptyStateLabel
        } else {
            tableView.backgroundView = nil
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func menuPressed(_ sender: Any) {
        validateButtonStatus()
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        performSegue(withIdentifier: "showFilterVC", sender: self)
    }
    
    
    @IBAction func deleteLibraryTapped(_ sender: Any) {
        deleteLibraryAlert()
    }
    
    func deleteLibraryAlert() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this library?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.deleteLibrary()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteBookAlertAction(for book: Int) {
        let deleteMessage = AlertMessage(title: "Delete", message: "Are you sure you want to delete this book?")
        self.alertDelegate?.displayAlert(message: deleteMessage, with: { _ in
                self.deleteBook(book)
        })
    }
    
    // MARK: - Error Method 
    // TODO: - Create error protocol
    
    func error(_ type: ErrorType) {
        self.errorHandler?.displayErrorAlert(message: type.errorMessage)
    }
    
    // MARK: - API Methods
    
    func deleteLibrary() {
        client.delete(from: .getLibrary) { (success) in
            if !success {
               self.error(.deletingLibrary)
            }
            self.fetch()
        }
    }
    
    func deleteBook(_ book: Int) {
        self.client.delete(from: .getBook(book), book: book) { (success) in
            if !success {
                self.error(.deletingBook)
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.fetch()
                }
            }
        }
    }
    
    func fetch() {
        self.store.getBooks { (success) in
            if !success {
                self.error(.retrievingBooks)
            } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }
        }
    }
    
    // MARK: - Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case SegueIdentifier.showDetailVC:
            
            let destVC = segue.destination as! DetailVC
            guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destVC.book = store.books[indexPath.row]
        case SegueIdentifier.showEditVC:
            let destVC = segue.destination as! EditBookVC
            guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destVC.book = store.books[indexPath.row]
        default:
            print("Could not segue")
            // Handle
        }
    }
    
}

// MARK: - Table View Methods

extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.bookCell, for: indexPath) as! BookCell
        let book = store.books[indexPath.row]
        
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Is force casting necessary?
        let bookID = self.store.books[indexPath.row].id as! Int
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteBookAlertAction(for: bookID)
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: SegueIdentifier.showEditVC, sender: tableView.cellForRow(at: indexPath))
        }
        return [delete, edit]
    }
}


// MARK: - Alert Delegate

extension LibraryVC: AlertDelegate {
    
    func displayAlert(message type: AlertMessage, with handler: @escaping (Any?) -> Void) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            handler(nil)
        })
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}

extension LibraryVC: ErrorHandling {
    
    func displayErrorAlert(message type: AlertMessage) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}

