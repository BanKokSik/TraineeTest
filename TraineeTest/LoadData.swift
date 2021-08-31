//
//  LoadData.swift
//  TraineeTest
//
//  Created by Nikita Chekmarev on 29.07.2021.
//

import Foundation
import Alamofire
import AlamofireImage

class LoadData {
    private init() {}
    
    static let shared: LoadData = LoadData()
    
    let data_url = "http://gallery.dev.webant.ru/api/photos?"
    let photos_url = "http://gallery.dev.webant.ru/media/"
    
    func loadPhotos(page: Int, newOrPop: Bool,  result: @escaping ((ImageModel?)->())) {
        var param: String
        
        if newOrPop {
          param = "new"
        } else {
          param = "popular"
        }
        
        let requestParams: Parameters =  [
            param: "true",
            "limit": "10",
            "page": page
        ]
        
        AF.request(data_url, method: .get, parameters: requestParams).responseDecodable(of: ImageModel.self) { response in
            result(response.value)
        }
    }
}
