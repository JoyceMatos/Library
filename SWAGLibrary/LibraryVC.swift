//
//  ViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Change all VC's to be named ViewController

class LibraryVC: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var deleteLibraryButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!

    // MARK: - Properties

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
        
//        GoogleAPIClient.sharedInstance.get("9780140047486") { (json) in
//            print("We did it!")
//        }
//        
        store.retrieve(scanned: "9780140047486") { (book) in
            print("HELLOOO")
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    // TODO: - Perhaps these should have their own view
    func showMenuButtons() {
        didDisplayOptions = true
        deleteLibraryButton.isHidden = false
        // TODO: - Animate menu button state
    }

    func hideMenuButtons() {
        didDisplayOptions = false
        deleteLibraryButton.isHidden = true
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

    // MARK: - Action Methods

    @IBAction func menuPressed(_ sender: Any) {
        validateButtonStatus()
    }

    @IBAction func deleteLibraryTapped(_ sender: Any) {
        deleteLibraryAlert()
    }


    // MARK: - Alert Methods

    func deleteLibraryAlert() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete all the books in your library?", preferredStyle: .alert)
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
    // TODO: - Add completion handler to all API functions

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

    func deleteLibrary() {
        client.delete(from: .deleteLibrary, completion: { (success) in
            if !success {
                self.errorHandler?.displayErrorAlert(for: .deletingLibrary)
            } else {
                DispatchQueue.main.async {
                    self.fetch()
                }
            }
        })
    }

    func deleteBook(_ book: Int) {
        self.client.delete(from: .getBook(book), completion: { (success) in
            if !success {
                self.errorHandler?.displayErrorAlert(for: .deletingBook)
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.fetch()
                }
            }
        })
    }


    // MARK: - Segue Methods

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


        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCell = cell as! BookCell
        let book = store.books[indexPath.row]
        currentCell.book = book
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        return 115
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
