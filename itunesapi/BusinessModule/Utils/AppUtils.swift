//
//  AppUtils.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//



struct AppUtils {
    
    static let movie:[String] = ["feature-movie"]
    static let music:[String] = ["music","song","track"]
    static let podcast:[String] = ["podcast"]
    static let musicVideo:[String] = ["music-video"]
    static let audiobook:[String] = ["audiobook"]  // only check wrapper type
    static let shortFilm:[String] = ["shortFilm"]
    static let tvShow:[String] = ["tv-episode","tv-episode"]
    static let software:[String] = ["software"]
    static let ebook:[String] = ["ebook"]

    static  let typeList:[MediaTypeModel] = [
        MediaTypeModel(key: "Movie", value: "movie", combination:["feature-movie"]),
        MediaTypeModel(key: "Podcast", value: "podcast", combination:["podcast"] ),
        MediaTypeModel(key: "Music", value: "music",combination: ["music","song","track"]),
        MediaTypeModel(key: "Music Video", value: "musicVideo", combination:["music-video"]),
        MediaTypeModel(key: "Audiobook", value: "audiobook", combination:["audiobook"] ),
        MediaTypeModel(key: "Shortv Film", value: "shortFilm", combination:["shortFilm"]),
        MediaTypeModel(key: "TV Show", value: "tvShow", combination: ["tv-episode","tv-episode"]),
        MediaTypeModel(key: "Software", value: "software", combination: ["software"]),
        MediaTypeModel(key: "Ebook", value: "ebook", combination: ["ebook"]),
    ]
    


    
}
