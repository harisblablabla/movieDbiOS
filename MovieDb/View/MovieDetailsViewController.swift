//
//  MovieDetailsViewController.swift
//  MovieDb
//
//  Created by Haris Fadhilah on 15/03/23.
//

import Foundation
import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    var movieID: Int = 0
    
    private var vm = MovieViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        bindVM()
        vm.getMovieDetails(movieID: self.movieID)
        vm.getMovieVideos(movieID: self.movieID)
        vm.getReviewVideos(movieID: self.movieID)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bindVM() {
        vm.objectWillChange.sink { _ in
            DispatchQueue.main.async {
                self.movieTitle.text = self.vm.movieDetails?.title
                self.movieBackdrop.downloadImage(from: URL(string: "https://image.tmdb.org/t/p/w1000_and_h563_face/\(self.vm.movieDetails?.backdrop ?? "")")!)
                self.movieReleaseDate.text = self.vm.movieDetails?.releaseDate
                self.movieRuntime.text = "Runtime: \(self.vm.movieDetails?.runtime ?? 0) minutes"
                self.movieGenre.text = self.vm.arrangeMovieGenresInHorizontalText()
                self.movieOverview.text = self.vm.movieDetails?.overview
                self.firstTable.reloadData()
                self.tableView2.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return stack
    }()
    
    func reusableStackView(spacing: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = spacing
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    lazy var topStackView = reusableStackView(spacing: 5)
    lazy var middleStackView = reusableStackView(spacing: 0)
    lazy var bottomStackView = reusableStackView(spacing: 0)
    
    lazy var firstTable: UITableView = {
        let firstTable = UITableView()
        firstTable.delegate = self
        firstTable.dataSource = self
        firstTable.register(UITableViewCell.self, forCellReuseIdentifier: "videoCell")
        firstTable.translatesAutoresizingMaskIntoConstraints = false
        return firstTable
    }()
    
    lazy var tableView2: UITableView = {
        let tableView2 = UITableView()
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "reviewCell")
        tableView2.translatesAutoresizingMaskIntoConstraints = false
        return tableView2
    }()
    
    lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var movieBackdrop: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var movieReleaseDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieRuntime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieGenre: UILabel = {
        let label = UILabel()
        label.text = "Genre: Romance, Animation, Drama"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieOverview: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var videosTitleText: UILabel = {
        let label = UILabel()
        label.text = "Videos"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reviewTitleText: UILabel = {
        let label = UILabel()
        label.text = "Review"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(topStackView)
        topStackView.addArrangedSubview(movieTitle)
        topStackView.addArrangedSubview(movieBackdrop)
        stackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(movieReleaseDate)
        middleStackView.addArrangedSubview(movieRuntime)
        middleStackView.addArrangedSubview(movieGenre)
        stackView.addArrangedSubview(movieOverview)
        stackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(videosTitleText)
        bottomStackView.addArrangedSubview(firstTable)
        bottomStackView.addArrangedSubview(reviewTitleText)
        bottomStackView.addArrangedSubview(tableView2)
    }
    
    func getTableViewHeightMultiplier() -> CGFloat {
        if vm.videos.count > 2 && vm.videos.count < 5 {
            return 0.3
        } else if vm.videos.count == 5 {
            return 0.6
        } else {
            return 0.5
        }
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            movieTitle.topAnchor.constraint(equalTo: topStackView.topAnchor),
            movieBackdrop.heightAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0.57),
            movieReleaseDate.topAnchor.constraint(equalTo: middleStackView.topAnchor),
            movieRuntime.topAnchor.constraint(equalTo: movieReleaseDate.bottomAnchor),
            movieGenre.topAnchor.constraint(equalTo: movieRuntime.bottomAnchor),
            firstTable.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: getTableViewHeightMultiplier()),
            tableView2.heightAnchor.constraint(equalTo: firstTable.heightAnchor, multiplier: 0.35)
        ])
    }
}


extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == firstTable {
            return vm.videos.count
        } else {
            return vm.reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == firstTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
            cell.textLabel?.text = vm.videos[indexPath.row].name
            cell.accessoryView = UIImageView(image: UIImage(systemName: "play.rectangle.fill"))
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
            cell.textLabel?.text = vm.reviews[indexPath.row].content
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == firstTable {
            firstTable.deselectRow(at: indexPath, animated: true)
            let url = URL(string: "https://www.youtube.com/watch?v=\(vm.videos[indexPath.row].key)")
            guard let unwrappedURL = url else { return }
            UIApplication.shared.open(unwrappedURL)
        } else {
            tableView2.deselectRow(at: indexPath, animated: true)
        }
    }
}

