//
//  SearchViewController.swift
//  MovieDb
//
//  Created by Haris Fadhilah on 15/03/23.
//

import Foundation
import UIKit
import Combine

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    private var vm = MovieViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    func setupBindings() {
        vm.objectWillChange.sink { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        definesPresentationContext = true
        return search
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
   
    func setupViews() {
        navigationItem.searchController = searchController
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
        ])
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            vm.getMovieDataFromSearch(searchText: text)
        } else {
            vm.searchedMovies.removeAll()
        }
        
        if !searchController.isActive {
            vm.searchedMovies.removeAll()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = vm.searchedMovies[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsView = MovieDetailsViewController()
        movieDetailsView.movieID = vm.searchedMovies[indexPath.row].id
        movieDetailsView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailsView, animated: true)
    }
}
