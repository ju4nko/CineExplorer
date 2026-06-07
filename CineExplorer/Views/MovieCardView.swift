//
//  MovieCardView.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment:.leading){
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(Color.gray.opacity(0.3))
                    .overlay(Image(systemName: "film").font(.largeTitle).foregroundColor(.gray))
            }
            .frame(height: 200)
            .clipped()
            .cornerRadius(10)
            
            Text(movie.title)
                .font(.headline)
                .lineLimit(2)
            HStack {
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text(String(format: "%.1f", movie.voteAverage))
                Spacer()
                Text(movie.year).foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    MovieCardView(movie: Movie(
        id: 1,
        title: "Sample Movie",
        overview: "A sample overview for preview purposes.",
        posterPath: nil,
        voteAverage: 7.5,
        releaseDate: "2026-01-01",
        genreIds: nil
    ))
}


