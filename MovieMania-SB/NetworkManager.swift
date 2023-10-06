//
//  NetworkManager.swift
//  MovieMania-SB
//
//  Created by Pierce Gallego on 10/5/23.
//

import Foundation

struct MovieListRequest {
    var request: URLRequest
    
    let baseURLString = "https://itunes.apple.com/search?term=star&country=au&media=movie&;all"
    
    init() {
        guard let urlComponents = URLComponents(string: baseURLString) else {
            fatalError("Invalid URL")
        }
        
        guard let url = urlComponents.url else {
            fatalError("Invalid URL")
        }
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 40
    }
    
    //fetch API results then map results to FetechResults
    
    func fetchMovieListRequest(completion: @escaping(Result<FetchResults, Error>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(FetchResults.self, from: data)
                completion(.success(jsonData))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }

}
