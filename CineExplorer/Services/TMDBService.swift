//
//  TMDBService.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//
import Foundation

@Observable
class TMDBService: MovieServicing {

    private let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
              !key.isEmpty else {
            fatalError("TMDB_API_KEY no está configurada en Info.plist")
        }
        return key
    }()
    private let baseURL = "https://api.themoviedb.org/3"

    var movies: [Movie] = []
    var genres: [Genre] = []
    var isLoading = false
    var errorMessage: String?
    
    func fetchPopular() async {
        await fetchMovies(endpoint: "/movie/popular")
    }
    
    func fetchTopRated() async {
        await fetchMovies(endpoint: "/movie/top_rated")
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
            let data = try await performRequest(url: url)
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

        do {
            let data = try await performRequest(url: url)
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            movies = decoded.results
        } catch {
            print("❌ Error: \(error)")
            errorMessage = "Error al cargar: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func performRequest(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200..<300).contains(http.statusCode) else {
            let serverMessage = (try? JSONDecoder().decode(TMDBErrorResponse.self, from: data))?.statusMessage
            let message = serverMessage ?? "Error HTTP \(http.statusCode)"
            throw NSError(
                domain: "TMDBService",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: message]
            )
        }
        return data
    }
}

private struct TMDBErrorResponse: Decodable {
    let statusMessage: String
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
    }
}
