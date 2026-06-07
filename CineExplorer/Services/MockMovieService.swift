//
//  MockMovieService.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//
import Foundation

@Observable
final class MockMovieService: MovieServicing {
    var movies: [Movie]
    var genres: [Genre]
    var isLoading: Bool
    var errorMessage: String?

    init(
        movies: [Movie] = MockMovieService.sampleMovies,
        genres: [Genre] = MockMovieService.sampleGenres,
        isLoading: Bool = false,
        errorMessage: String? = nil
    ) {
        self.movies = movies
        self.genres = genres
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }

    func fetchPopular() async {}
    func fetchNowPlaying() async {}
    func fetchTopRated() async {}
    func searchMovies(query: String) async {}
    func fetchGenres() async {}

    static let sampleMovies: [Movie] = [
        Movie(
            id: 1,
            title: "Dune: Parte Dos",
            overview: "Paul Atreides se une a los Fremen.",
            posterPath: nil,
            voteAverage: 8.4,
            releaseDate: "2026-03-01",
            genreIds: [878, 12]
        ),
        Movie(
            id: 2,
            title: "Oppenheimer",
            overview: "La historia del padre de la bomba atómica.",
            posterPath: nil,
            voteAverage: 8.1,
            releaseDate: "2026-07-21",
            genreIds: [18, 36]
        )
    ]

    static let sampleGenres: [Genre] = [
        Genre(id: 28, name: "Acción"),
        Genre(id: 18, name: "Drama"),
        Genre(id: 878, name: "Ciencia ficción")
    ]
}
