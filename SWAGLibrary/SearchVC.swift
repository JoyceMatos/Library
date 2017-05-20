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

class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var customSearchBar: CustomSearchBar!
    
    let store = LibraryDataStore.sharedInstance
    var filteredBooks = [Book]()
    var shouldShowSearchResults = false
    
    var errorHandler: ErrorHandling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorHandler = self
        fetch()
        configureSearchController()
        
    }
    
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
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    
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
        
        // Maybe filter instead
        for book in store.books {
            let bookTitle = book.title.lowercased()
            if bookTitle.contains(searchString.lowercased()) {
                filteredBooks = [book]
            }
        }
        
        tableView.reloadData()
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
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




extension SearchVC: ErrorHandling {
    
    func displayErrorAlert(for type: ErrorType) {
        let alert = UIAlertController(title: type.errorMessage.title, message: type.errorMessage.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
