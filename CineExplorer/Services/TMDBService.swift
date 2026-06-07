//
//  TMDBService.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//
import Foundation
import Combine

class TMDBService: ObservableObject {
    
    private let apiKey = "088c5a683f8a5bc0a55090bd59c6e8fc"
    private let baseURL = "https://api.themoviedb.org/3"
    
    @Published var movies: [Movie] = []
    @Published var genres: [Genre] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchPopular() async {
        await fetchMovies(endpoint: "/movie/popular")
    }
    
    func fetchNowPlaying() async {
        await fetchMovies(endpoint: "/movie/now_playing")
    }
    
    func searchMovies(query: String) async {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        await fetchMovies(endpoint: "/search/movie", extraParams: "query=\(encoded)")
    }

    @MainActor
    func fetchGenres() async {
        var components = URLComponents(string: "\(baseURL)/genre/movie/list")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "es-ES")
        ]
        guard let url = components.url else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(GenreResponse.self, from: data)
            genres = decoded.genres
        } catch {
            print("❌ Error géneros: \(error)")
        }
    }
    
    @MainActor
    private func fetchMovies(endpoint: String, extraParams: String = "") async {
        isLoading = true
        errorMessage = nil
        
        var components = URLComponents(string: "\(baseURL)\(endpoint)")!
        var queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "es-ES")
        ]
        if !extraParams.isEmpty {
            // extraParams viene como "query=batman"
            let parts = extraParams.split(separator: "=")
            if parts.count == 2 {
                queryItems.append(URLQueryItem(name: String(parts[0]), value: String(parts[1])))
            }
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            errorMessage = "URL inválida"
            isLoading = false
            return
        }
        
        print("🔗 URL: \(url)") // Debug — bórralo cuando funcione
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            movies = decoded.results
        } catch {
            print("❌ Error: \(error)") // Muestra el error exacto en consola
            errorMessage = "Error al cargar: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
