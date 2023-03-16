//
//  NetworkConstant.swift
//  MovieDb
//
//  Created by Haris Fadhilah on 16/03/23.
//

import Foundation

enum MovieBaseURL {
    static let baseURL =  "https://api.themoviedb.org/3/"
    static let now_playing = "movie/now_playing"
    static let upcoming = "movie/upcoming"
    static let top_rated = "movie/top_rated"
    static let apiKey = "?api_key=783a4485ba37ff63e4a463f044195611"
    static let page = "&page="
    static let appendToResponse = "&append_to_response="
}

enum MovieRequest: String {
    case reviews = "reviews"
    case videos = "videos"
}
