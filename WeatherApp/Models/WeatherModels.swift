//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Anwesh on 3/20/23.
//

import Foundation

class WeatherErrorModel: Decodable{
    let code, message: String!
}



// MARK: - WeatherModel
class WeatherModel: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]?
    let city: City?
    
    init(cod: String, message: Int, cnt: Int, list: [List], city: City) {
        self.cod = cod
        self.message = message
        self.cnt = cnt
        self.list = list
        self.city = city
    }
}

// MARK: - City
class City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
    
    init(id: Int, name: String, coord: Coord, country: String, population: Int, timezone: Int, sunrise: Int, sunset: Int) {
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        self.population = population
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

// MARK: - Coord
class Coord: Decodable {
    let lat, lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

// MARK: - List
class List: Decodable {
    let dt: Date
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
//    let sys: AnyObject?
    let dtTxt: String
    let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop
        case dtTxt = "dt_txt"
        case rain
    }
    
    init(dt: Date, main: MainClass, weather: [Weather], clouds: Clouds, wind: Wind, visibility: Int, pop: Double, dtTxt: String, rain: Rain?) {
        self.dt = dt
        self.main = main
        self.weather = weather
        self.clouds = clouds
        self.wind = wind
        self.visibility = visibility
        self.pop = pop
//        self.sys = sys
        self.dtTxt = dtTxt
        self.rain = rain
    }
}

// MARK: - Clouds
class Clouds: Decodable {
    let all: Int
    
    init(all: Int) {
        self.all = all
    }
}

// MARK: - MainClass
class MainClass: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
    
    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, pressure: Int, seaLevel: Int, grndLevel: Int, humidity: Int, tempKf: Double) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.seaLevel = seaLevel
        self.grndLevel = grndLevel
        self.humidity = humidity
        self.tempKf = tempKf
    }
}

// MARK: - Rain
class Rain: Decodable {
    let the3H: Double
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
    
    init(the3H: Double) {
        self.the3H = the3H
    }
}


// MARK: - Weather
class Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    init(id: Int, main: String, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}


// MARK: - Wind
class Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
    
    init(speed: Double, deg: Int, gust: Double) {
        self.speed = speed
        self.deg = deg
        self.gust = gust
    }
}
