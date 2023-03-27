//
//  Show.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import Foundation

struct ShowsResponse: Codable {
    let results: [Show]
}

struct Show: Codable {
    let id: Int
    let media_type: String?
    let name: String?
    let original_name: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let vote_average: Double?
}
