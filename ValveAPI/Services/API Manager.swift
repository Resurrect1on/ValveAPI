//
//  API Manager.swift
//  ValveAPI
//
//  Created by Dmitry on 02.03.2023.
//

import Foundation

enum ApiType {
    case proPlayers

    var baseURL: String {
        return "https://api.opendota.com/api/"
    }
    var headers: [String:String] {
        return [:]
    }

    var path: String {
        switch self {
        case .proPlayers:
            return "proPlayers"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL))
        var request = URLRequest(url: url!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        return request
    }
}

class ApiManager {
    
    static let shared = ApiManager()
    
    func getInformation(completion: @escaping (ProPlayers) -> Void) {
        let request = ApiType.proPlayers.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let players = try?JSONDecoder().decode(ProPlayers.self, from: data) {
                completion(players)
            } else {
                completion([])
            }
        }
        task.resume()
    }
}
