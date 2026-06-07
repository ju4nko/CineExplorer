//
//  Movie.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//
import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String?  // <- opcional por si viene vacío
    let genreIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath   = "poster_path"
        case voteAverage  = "vote_average"
        case releaseDate  = "release_date"
        case genreIds     = "genre_ids"
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var year: String {
        String((releaseDate ?? "").prefix(4))
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Genre: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

struct GenreResponse: Codable {
    let genres: [Genre]
}
