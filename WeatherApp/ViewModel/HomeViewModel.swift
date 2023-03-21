//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Anwesh on 3/20/23.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject{
    let impCities: [String] = ["Hyderabad", "Bangalore", "Delhi", "Mumbai", "Pune"]
    private var cancellables = Set<AnyCancellable>()
    
    @Published var cityName: String = String()
    @Published var weatherData: WeatherModel!
    @Published var errorMessage = String()
    @Published var showWeatherView: Bool = false
    
    func getWeatherData(){
        guard cityName.count > 0 else{
            errorMessage = "Please enter city name"
            return
        }
        HttpUtility.shared.get5DaysWeatherForecast(cityName: cityName).receive(on: RunLoop.main).sink { [weak self] completion in
            if case let .failure(error) = completion {
                    var msg = String()
                    switch error {
                    case .invalidURL:
                        msg = "Invalid URL"
                    case .responseError(let data):
                        if let data, let errorModel = try? JSONDecoder().decode(WeatherErrorModel.self, from: data){
                            msg = errorModel.message
                            break
                        }
                        msg = "Invalid Response"
                    case .unknown:
                        msg = "Unknown Error"
                    case .decodingError:
                        msg = "Decoding error"
                    }
                    self?.errorMessage = msg
            }
            
        } receiveValue: { [weak self] model in
            self?.weatherData = model
            self?.showWeatherView = true
        }.store(in: &cancellables)

    }
    
}
