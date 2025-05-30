import Foundation

struct DetailedPodcast: Decodable {
    let id: String
    let name: String
    let imageUrl: URL
    let releaseDate: Date
    let trackCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "artworkUrl600"
        case releaseDate
        case trackCount
    }
}

//{
//    "resultCount": 1,
//    "results": [
//        {
//            "wrapperType": "track",
//            "kind": "podcast",
//            "collectionId": 1403172116,
//            "trackId": 1403172116,
//            "artistName": "Kryminatorium",
//            "collectionName": "Kryminatorium",
//            "trackName": "Kryminatorium",
//            "collectionCensoredName": "Kryminatorium",
//            "trackCensoredName": "Kryminatorium",
//            "collectionViewUrl": "https://podcasts.apple.com/us/podcast/kryminatorium/id1403172116?uo=4",
//            "feedUrl": "https://anchor.fm/s/ff12104c/podcast/rss",
//            "trackViewUrl": "https://podcasts.apple.com/us/podcast/kryminatorium/id1403172116?uo=4",
//            "artworkUrl30": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/30x30bb.jpg",
//            "artworkUrl60": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/60x60bb.jpg",
//            "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/100x100bb.jpg",
//            "collectionPrice": 0,
//            "trackPrice": 0,
//            "collectionHdPrice": 0,
//            "releaseDate": "2025-05-26T03:00:00Z",
//            "collectionExplicitness": "notExplicit",
//            "trackExplicitness": "cleaned",
//            "trackCount": 371,
//            "trackTimeMillis": 1643,
//            "country": "USA",
//            "currency": "USD",
//            "primaryGenreName": "True Crime",
//            "contentAdvisoryRating": "Clean",
//            "artworkUrl600": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/600x600bb.jpg",
//            "genreIds": [
//                "1488",
//                "26"
//            ],
//            "genres": [
//                "True Crime",
//                "Podcasts"
//            ]
//        }
//    ]
//}
