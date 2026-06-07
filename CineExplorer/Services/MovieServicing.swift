//
//  MovieServicing.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//
import Foundation
import Observation

protocol MovieServicing: AnyObject, Observable {
    var movies: [Movie] { get }
    var genres: [Genre] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func fetchPopular() async
    func fetchNowPlaying() async
    func searchMovies(query: String) async
    func fetchGenres() async
}
