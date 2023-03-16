//
//  MovieViewModel.swift
//  MovieDb
//
//  Created by Haris Fadhilah on 15/03/23.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var topRated: [Movie] = []
    @Published var movieDetails: Movie?
    @Published var videos: [Videos] = []
    @Published var searchedMovies: [Movie] = []
    @Published var reviews: [Reviews] = []
    
    private var network = NetworkManager()
    
    func getNowPlayingMovie(page index: Int) {
        let url = MovieBaseURL.baseURL + MovieBaseURL.now_playing + MovieBaseURL.apiKey + MovieBaseURL.page + "\(index)"
        network.fetchMovieDataFromAPI(url: url, expecting: MovieResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.nowPlaying = movie.results
                }
            }
        }
    }
    
    func getUpcomingMovie() {
        let url = MovieBaseURL.baseURL + MovieBaseURL.upcoming + MovieBaseURL.apiKey
        network.fetchMovieDataFromAPI(url: url, expecting: MovieResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.upcoming = movie.results
                }
            }
        }
    }
    
    func getTopRatedMovie() {
        let url = MovieBaseURL.baseURL + MovieBaseURL.top_rated + MovieBaseURL.apiKey
        network.fetchMovieDataFromAPI(url: url, expecting: MovieResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.topRated = movie.results
                }
            }
        }
    }
    
    func getMovieDetails(movieID: Int) {
        network.fetchMovieDataFromAPI(url: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=dd961bfa9a816030820499683fe54a36", expecting: Movie.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.movieDetails = movie
                }
            }
        }
    }
    
    func getMovieVideos(movieID: Int) {
        network.fetchMovieDataFromAPI(url: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=dd961bfa9a816030820499683fe54a36", expecting: VideoResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let video):
                DispatchQueue.main.async {
                    print(video.results)
                    self?.videos = video.results
                }
            }
        }
    }
    
    func getReviewVideos(movieID: Int) {
        network.fetchMovieDataFromAPI(url: "https://api.themoviedb.org/3/movie/\(movieID)/reviews?api_key=dd961bfa9a816030820499683fe54a36", expecting: ReviewResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let review):
                DispatchQueue.main.async {
                    print(review.results)
                    self?.reviews = review.results
                }
            }
        }
    }
    
    func getMovieDataFromSearch(searchText: String) {
        network.fetchMovieDataFromAPI(url: "https://api.themoviedb.org/3/search/movie?api_key=dd961bfa9a816030820499683fe54a36&language=en-US&query=\(searchText)", expecting: MovieResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.searchedMovies = movie.results
                }
            }
        }
    }
    
    func arrangeMovieGenresInHorizontalText() -> String {
        var joinedWords = ""
        
        self.movieDetails?.genres?.forEach({ genre in
            joinedWords.append("\(genre.name), ")
        })
        
        return joinedWords
    }
}

