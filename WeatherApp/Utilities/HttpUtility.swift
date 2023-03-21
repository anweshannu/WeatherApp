//
//  HttpUtility.swift
//  WeatherApp
//
//  Created by Anwesh on 3/20/23.
//

import Foundation
import Combine

struct Constants{
    static let apiKey: String = "26c103e06afe7a44d92bae61b381953f"
}


protocol HTTPProtocol{
    //    func get5DaysWeatherForecast() async -> WeatherModel?
}

class HttpUtility: HTTPProtocol{
    
    private init(){}
    
    static let shared = HttpUtility()
    
    private var cancellables = Set<AnyCancellable>()
    
    func get5DaysWeatherForecast(cityName: String) -> Future<WeatherModel, NetworkError> {
        webRequest(endpoint: .get5DaysForecastForCity(cityName: cityName))
    }
    
    func get5DaysWeatherForecast(lat: String, long: String) -> Future<WeatherModel, NetworkError> {
        webRequest(endpoint: .get5DaysForecastForLatLon(lat: lat, long: long))
    }
    
    
    private func webRequest<T: Decodable>(endpoint: Endpoints) -> Future<T, NetworkError> {
        Future<T, NetworkError> { [weak self] promise in
            
            guard let self else{return}
            
            guard let url = URL(string: endpoint.url) else{
                return promise(.failure(NetworkError.invalidURL))
            }
            
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = endpoint.httpMethod
            urlRequest.allHTTPHeaderFields = endpoint.headers
            
            if endpoint.httpMethod != "GET", let body = endpoint.body, let data = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted){
                urlRequest.httpBody = data
            }
            
            endpoint.headers?.forEach({ header in
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            })
            
            URLSession.shared.dataTaskPublisher(for: urlRequest).tryMap { (data, response) in
                print(data.printJson())
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.responseError(data: data)
                }
                
#if DEBUG
                do {
                    _ = try JSONDecoder().decode(T.self, from: data)
                }
                catch{
                    print(error)
                    print(error.localizedDescription)
                }
#endif
                
                return data
            }.decode(type: T.self, decoder: JSONDecoder()).receive(on: RunLoop.main).sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case _ as DecodingError:
                        promise(.failure(.decodingError))
                    case let apiError as NetworkError:
                        promise(.failure(apiError))
                    default:
                        promise(.failure(NetworkError.unknown))
                    }
                }
            } receiveValue: { res in
                promise(.success(res))
            }.store(in: &self.cancellables)
        }
    }
    
    
}




protocol EndpointProtocol {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
}


enum Endpoints: EndpointProtocol{
    
    case get5DaysForecastForCity(cityName: String)
    case get5DaysForecastForLatLon(lat: String, long: String)
    
    
    var baseURLString: String{
        return "https://api.openweathermap.org"
    }
    
    var path: String{
        let apiKey: String = Constants.apiKey
        switch self {
        case .get5DaysForecastForCity(let cityName):
            return "/data/2.5/forecast?q=\(cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&appid=\(apiKey)&units=metric"
        case .get5DaysForecastForLatLon(let lat, let long):
            return "/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        }
    }
    
    var url: String {
        return self.baseURLString + self.path
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var httpMethod: String {
        switch self{
        default:
            return "GET"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case responseError(data: Data?)
    case unknown
}

extension Data {
    
    func printJson() {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                print("Inavlid data")
                return
            }
            print(jsonString)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
