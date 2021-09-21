//
//  HTStruct.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 9/20/21.
//

import Foundation

struct Response: Codable {
    var current: Weather
}
struct Weather: Codable {
    var temp: Float
    var humidity: Float
    var uvi: Float
    var wind_speed: Float
}
