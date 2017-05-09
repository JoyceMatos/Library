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
// TODO: - Look over file organization ie: Error, Alert, etc
// TODO: - Should VC's be final?
// TODO: - Make sure all naming conventions are appropriate!
// TODO: - Remove all unwanted images from assets
// TODO: - Figure out where to put delete all button
// TODO: - Create extension dedication to alerts only 
// TODO: - Work on background colors
// TODO: - Add notes for Linn

class LibraryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteLibraryButton: UIButton!
    @IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    let refresher = UIRefreshControl()
    
    let client = LibraryAPIClient.sharedInstance
    let store = LibraryDataStore.sharedInstance
    var errorHandler: ErrorHandling?
    var didDisplayOptions = false
    
    // MARK: - View Lifecyle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorHandler = self
        fetch()
        observe()
        refresh()
        hideMenuButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureEmptyState()
        animateTable()
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
            // TODO: - Do this in storyboard
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
    
    @IBAction func searchPressed(_ sender: UISearchBar) {

    }
    
    
    // MARK: - Alert Methods
    
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
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this book?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.deleteBook(book)
        })
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - API Methods
    
    func deleteLibrary() {
        client.delete(from: .getLibrary) { (success) in
            if !success {
                self.errorHandler?.displayErrorAlert(for: .deletingLibrary)
            }
            self.fetch()
        }
    }
    
    func deleteBook(_ book: Int) {
        self.client.delete(from: .getBook(book), book: book) { (success) in
            if !success {
                self.errorHandler?.displayErrorAlert(for: .deletingBook)
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
                self.errorHandler?.displayErrorAlert(for: .retrievingBooks)
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
        
        // Make background off color instead
        cell.bookView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.bookView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cell.bookView.layer.shadowOpacity = 0.09
        cell.bookView.layer.shadowRadius = 20
        cell.bookView.layer.cornerRadius = 6

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let bookID = self.store.books[indexPath.row].id as! Int
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteBookAlertAction(for: bookID)
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: SegueIdentifier.showEditVC, sender: tableView.cellForRow(at: indexPath))
        }
        return [delete, edit]
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 0.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    
}




// MARK: - Error Delegate

extension LibraryVC: ErrorHandling {
    
    func displayErrorAlert(for type: ErrorType) {
        let alert = UIAlertController(title: type.errorMessage.title, message: type.errorMessage.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}

