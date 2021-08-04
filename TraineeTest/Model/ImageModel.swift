//
//  ImageModel.swift
//  TraineeTest
//
//  Created by Nikita Chekmarev on 27.07.2021.
//

import Foundation

struct ImageModel: Codable {
    
    var data: [DataModel]?
    var countOfPages: Int?
    
}
struct DataModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case dateCreate = "dateCreate"
        case desc = "description"
        case new = "new"
        case popular = "popular"
        case image = "image"
        case user = "user"
    }
    
    var id: Int?
    var name: String?
    var dateCreate: String?
    var desc: String?
    var new: Bool?
    var popular: Bool?
    var image: Image?
    var user: String?
    
}
struct Image: Codable {
    
    var id: Int?
    var name: String?
    
}

struct ImageRequestModel: Codable {
    
    var file: String?
    var id: Int?
    var name: String?
    
}


