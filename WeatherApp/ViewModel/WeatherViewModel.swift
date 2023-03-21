//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Anwesh on 3/21/23.
//

import Foundation

struct WeatherViewDataModel{
    let city: String
    let data: [WeatherData]
}

struct WeatherData{
    let date: Date
    let temp: String
    let description: String
}
