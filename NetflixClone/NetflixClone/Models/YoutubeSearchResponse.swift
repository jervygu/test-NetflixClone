//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/28/23.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: YoutubePageInfo
    let items: [YoutubeItem]
}
struct YoutubeItem: Codable {
    let kind, etag: String
    let id: YoutubeItemID
}

struct YoutubeItemID: Codable {
    let kind, videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

struct YoutubePageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
