//
//  FlickrAPI.swift
//  NoamTest
//
//  Created by Noam Maydani on 2/4/22.
//

import Foundation
import Alamofire

class FlickrAPI {
    static let shared = FlickrAPI()
    private init() {}
    
    private let basicURL = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent"
    private let authKey = "aabca25d8cd75f676d3a74a72dcebf21"
    
    func getPhotos(page: Int, complition: @escaping(ApiResponse) -> Void) {
        AF.request("\(basicURL)&page=\(page)&per_page=20&api_key=\(authKey)&format=json&nojsoncallback=1").responseData { response in
            guard let data = response.data, let photoResponse = try? JSONDecoder().decode(ApiResponse.self, from: data) else { return }
            complition(photoResponse)
        }
    }
}
struct ApiResponse: Codable {
    let photos: PhotosResponse
}

struct PhotosResponse: Codable {
    let page: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
}

