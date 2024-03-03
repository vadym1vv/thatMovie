//
//  MovieDataVM.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 25.12.2023.
//

import Foundation



struct MovieDataVM {
    
    func isFavourite(moviesDb: [MovieItem], id: Int) -> Bool {
        return moviesDb.contains(where: {$0.id == id && $0.personalIsFavourite})
    }

    
    func isDateToWatchSet(moviesDb: [MovieItem], id: Int) -> Bool {
        return moviesDb.contains(where: {$0.id == id && ($0.personalDateToWatch != nil)})
    }
    
    func setFavouriteById(movieDb: MovieItem?, id: Int?, title: String?, posterPath: String?, releaseDate: Date?) -> MovieItem? {
        if let movie = movieDb {
            movie.personalIsFavourite.toggle()
            return nil
        }      
        return MovieItem(id: id, title: title, posterPath: posterPath, releaseDate: releaseDate, personalIsFavourite: true)
    }

    
    func setPlannedToWatch(movieDb: MovieItem?, id: Int?, genres: [Int]?, title: String?, posterPath: String?, releaseDate: Date? ) -> MovieItem? {
        if let movie = movieDb {
            movie.personalIsPlannedToWatch = true
            movie.personalDateToWatch = nil
            return nil
        }
        
        return MovieItem(id: id, genreIDS: genres, title: title, posterPath: posterPath, releaseDate: releaseDate, personalDateToWatch: nil, personalIsPlannedToWatch: true)
    }
    
    
    func setDateToWatch(movieDb: MovieItem?, newDateToWatch: Date, id: Int?, genres: [Int]?, title: String?, posterPath: String?, releaseDate: Date?) -> MovieItem? {
        if let movie = movieDb {
            movie.personalDateToWatch = newDateToWatch
            return nil
        }
        
        return MovieItem(id: id, genreIDS: genres, title: title, posterPath: posterPath, releaseDate: releaseDate, personalDateToWatch: newDateToWatch, personalIsPlannedToWatch: false)
    }
    
    
    
}
