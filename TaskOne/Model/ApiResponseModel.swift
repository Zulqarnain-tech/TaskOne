//
//  ApiResponseModel.swift
//  TaskOne
//
//  Created by Zulqarnain on 19/02/2022.
//

import Foundation

import Foundation

struct ImagesResponse: Decodable {
    let errorMessage: String
    let images: [Images]

    enum CodingKeys: String, CodingKey {
        case images = "data"
        case errorMessage
    }
}

struct Images: Decodable {
    let image: String
}
