//
//  MovieDetailDataModel.swift
//  iOS_OTT
//
//  Created by 최민준 on 12/11/23.
//

import Foundation


struct MovieDetailDataModel: Codable {
    var adult: Bool?
    var backdropPath: String?
    var belongs_to_collection: BelongsToCollection?
    var budget: Int?
    var geners: [Geners]?
    var homepage: String?
    var id: Int?
    var imdbId: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var production_companies: [ProductionCompanies]?
    var production_countries: [ProductionCountries]?
    var releaseDate: String?
    var revenue: Int?
    var runtime: Int?
    var spoken_languages: [SpokenLanguage]?
    var status: String?
    var tagline: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongs_to_collection
        case budget, geners, homepage, id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case production_companies, production_countries
        case releaseDate = "release_date"
        case revenue, runtime, spoken_languages, status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    struct BelongsToCollection: Codable {
        var id: Int?
        var name: String?
        var posterPath: String?
        var backdropPath: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
        }
    }
    
    struct Geners: Codable {
        var id: Int?
        var name: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
        }
    }
    
    struct ProductionCompanies: Codable {
        var id: Int?
        var logoPath: String?
        var name: String?
        var originCountry: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case logoPath = "logo_path"
            case name
            case originCountry = "origin_country"
        }
    }
    
    struct ProductionCountries: Codable {
        var iso_3166_1: String?
        var name: String?
        
        enum CodingKeys: String, CodingKey {
            case iso_3166_1, name
        }
    }
    
    struct SpokenLanguage: Codable {
        var englishName: String?
        var iso_639_1: String?
        var name: String?
        
        enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case iso_639_1, name
        }
    }
}
