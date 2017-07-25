//
//  SearchVC.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/19/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit

// TODO: - Work on error handling
// TODO: - Seperate view functionality
// TODO: - Add search by author

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var customSearchBar: CustomSearchBar!
    let store = LibraryDataStore.sharedInstance
    var filteredBooks = [Book]()
    var shouldShowSearchResults = false
    var errorHandler: ErrorHandling?
    
    // MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorHandler = self
        fetch()
        configureSearchController()
    }
    
    // MARK: - API Method
    
    func fetch() {
        self.store.getBooks { (success) in
            if !success {
                self.errorHandler?.displayErrorAlert(for: .retrievingBooks)
            } else {
                DispatchQueue.main.async {
                    print("heyyy lets get the books y'all")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - View Method
    
    // TODO: - Try customizing this in storybaord
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by title"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.darkGray
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

// MARK: - Search Methods

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        // Resign the search field from first responder once the Search button in the keyboard gets tapped
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        filteredBooks.removeAll()
        
        // Maybe filter instead
        for book in store.books {
            let bookTitle = book.title.lowercased()
            let bookAuthor = book.author.lowercased()
            if bookTitle.contains(searchString.lowercased()) || bookAuthor.contains(searchString.lowercased()) {
                filteredBooks.append(book)

            }
        }
        
        tableView.reloadData()
    }
}

// MARK: - TableView Methods

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredBooks.count
        } else {
            return store.books.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCell = cell as! SearchCell
        
        if shouldShowSearchResults {
            let book = filteredBooks[indexPath.row]
            currentCell.book = book
        } else {
            let book = store.books[indexPath.row]
            currentCell.book = book
        }
    }
}

// MARK: - Error Handling Method

extension SearchViewController: ErrorHandling {
    
    func displayErrorAlert(for type: ErrorType) {
        let alert = UIAlertController(title: type.errorMessage.title, message: type.errorMessage.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
