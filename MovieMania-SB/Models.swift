//
//  Models.swift
//  MovieMania-SB
//
//  Created by Pierce Gallego on 10/5/23.
//

import Foundation

struct FetchResults: Codable {
    let resultCount: Int?
    let results: [MovieFetchResult]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
    
}

struct MovieFetchResult: Codable, Identifiable {
    let id = UUID()
    let trackName: String?
    let trackId: Int
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let trackPrice: Float?
    let currency, primaryGenreName, shortDescription, longDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case trackName, trackId, artworkUrl30, artworkUrl60, artworkUrl100, trackPrice, primaryGenreName, shortDescription, longDescription, currency
    }
}

struct MovieDetail: Codable, Identifiable {
    var id = UUID()
    let movie: MovieFetchResult
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, movie, isFavorite
    }
}

//MARK: - Mock Data

struct MockMovieData {
    static let sampleMovie = MovieDetail(
        movie: MovieFetchResult(
            trackName: "Hi",
            trackId: 123,
            artworkUrl30: "URL 30",
            artworkUrl60: "URL 60",
            artworkUrl100: "URL 100",
            trackPrice: 12.21, currency: "PHP",
            primaryGenreName: "Action",
            shortDescription: "Shosrgsdfsgcv sdfdf",
            longDescription: "sdfbjhnzf srogjsnfd jgk d ogjsndfgjkn f"),
        isFavorite: false)
    
    
    static let movies = [sampleMovie, sampleMovie]
}
