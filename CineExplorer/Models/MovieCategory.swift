//
//  MovieCategory.swift
//  CineExplorer
//
//  Created by Juanjo on 07/06/2026.
//

import Foundation

enum MovieCategory: CaseIterable, Hashable {
    case popular, nowPlaying, topRated
    var displayName: String {
        switch self {
            case .popular: "Populares"
            case .nowPlaying: "En Cartelera"
            case .topRated: "Mejor valorados"
        }
    }
}
