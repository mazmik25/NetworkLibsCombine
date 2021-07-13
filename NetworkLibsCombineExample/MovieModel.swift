//
//  MovieModel.swift
//
//  MIT License
//
//  Copyright (c) 2021 Azmi Muhammad
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

struct GetMoviesBodyResponse: Codable {
    let dates: MovieDateResponse?
    let page: Int?
    let results: [GetMoviesFullBodyResponse]
    let totalPages: Int?
    let totalResults: Int?
}

struct GetMoviesFullBodyResponse: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?
}

struct MovieDateResponse: Codable {
    let maximum: String
    let minimum: String
}

struct MoviesOutput: Codable, CustomStringConvertible {
    let title: String?
    let synopsis: String?
    let posterPath: String?
    
    var description: String {
        return """
            Title: \(title ?? ""),
            Synopsis: \(synopsis ?? ""),
            Poster path: \(posterPath ?? "")
        """
    }
}
