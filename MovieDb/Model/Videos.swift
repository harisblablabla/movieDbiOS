//
//  Videos.swift
//  MovieDb
//
//  Created by Haris Fadhilah on 15/03/23.
//

import Foundation

struct VideoResponse: Codable {
    var results: [Videos]
}

struct Videos: Codable {
    let id: String
    let name: String
    let key: String
}

struct ReviewResponse: Codable {
    var results: [Reviews]
}

struct Reviews: Codable {
    let id: String
    let author: String
    let content: String
    let created_at: String
}
