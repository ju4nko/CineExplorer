//
//  MovieDetailView.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: movie.posterURL) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title).font(.title).bold()
                    
                    HStack {
                        Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        Text("· \(movie.year)").foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Text("Sinopsis").font(.headline)
                    Text(movie.overview.isEmpty ? "Sin descripción disponible." : movie.overview)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
}
#Preview {
    MovieDetailView(
        movie: Movie(
            id: 1,
            title: "Película de ejemplo",
            overview: "Esta es una sinopsis de ejemplo para la vista previa.",
            posterPath: nil,
            voteAverage: 7.8,
            releaseDate: "2026-01-15",
            genreIds: nil
        )
    )
}
