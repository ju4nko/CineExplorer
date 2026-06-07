//
//  ContentView.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI


struct ContentView: View {
    @State private var service: any MovieServicing
    @State private var searchText = ""
    @State private var movieCategory: MovieCategory = .popular
    @State private var selectedGenreId: Int? = nil
    
    
    
    init(service: any MovieServicing = TMDBService()) {
        _service = State(initialValue: service)
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private var filteredMovies: [Movie] {
        guard let genreId = selectedGenreId else { return service.movies }
        return service.movies.filter { $0.genreIds?.contains(genreId) ?? false }
    }
    
    private var selectedGenreName: String {
        guard let genreId = selectedGenreId,
              let genre = service.genres.first(where: { $0.id == genreId }) else {
            return "Todos los géneros"
        }
        return genre.name
    }
    
    private func loadCurrentTab() async {
        
        switch  movieCategory {
        case .popular: await service.fetchPopular()
        case .nowPlaying: await service.fetchNowPlaying()
        case .topRated: await service.fetchTopRated()
        }
        
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                // Tabs
                Picker("Categoría", selection: $movieCategory) {
                    ForEach(MovieCategory.allCases, id: \.self) { categoria in
                        Text(categoria.displayName).tag(categoria)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Filtro de género
                Menu {
                    Button("Todos los géneros") { selectedGenreId = nil }
                    ForEach(service.genres) { genre in
                        Button(genre.name) { selectedGenreId = genre.id }
                    }
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text(selectedGenreName)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
                
                if service.isLoading {
                    ProgressView("Cargando...").padding()
                } else if let error = service.errorMessage {
                    Text(error).foregroundColor(.red).padding()
                } else if filteredMovies.isEmpty {
                    Text("No hay películas para este género.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView{
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredMovies) { movie in
                                let nombres = movie.genreNames(in:service.genres)
                                NavigationLink(destination: MovieDetailView(movie: movie, genreNames: nombres)){
                                    MovieCardView(movie: movie,genreNames: nombres)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }.refreshable {
                        await loadCurrentTab()
                    }
                }
            }
            .navigationTitle("Cine Explorer")
            .searchable(text: $searchText, prompt: "Buscar película...")
            .onSubmit(of: .search) {
                Task { await service.searchMovies(query: searchText) }
            }
            .onChange(of: searchText) { _, newValue in
                if newValue.isEmpty {
                    Task {
                        await loadCurrentTab()
                    }
                }
            }
            .onChange(of: movieCategory) {
                Task {
                    await loadCurrentTab()
                }
            }
            .task {
                await service.fetchGenres()
                await loadCurrentTab()
            }
        }
    }
}

#Preview("Con datos") {
    ContentView(service: MockMovieService())
}

#Preview("Cargando") {
    ContentView(service: MockMovieService(movies: [], isLoading: true))
}

#Preview("Error") {
    ContentView(service: MockMovieService(movies: [], errorMessage: "Error de red"))
}
