//
//  HTClient.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 9/18/21.
//

import Foundation
import UIKit
import MapKit

class HTClient{
    var persistenceCont = HTPerCont()
    func getJson(_ lat: Double, _ lon: Double, completion: @escaping (_ response: Response?, _ error: Error?, _ success: Bool)-> ()) {
        let urlString =  "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=f263544bb99e65fba638f5938cbe8ef7"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, err in
                if let data = data {
                    do {
                        let json: Response = try JSONDecoder().decode(Response.self, from: data)
                        completion(json, nil, true)
                    }catch let error {
                        completion(nil, error, false)
                        print("api error" + error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}
