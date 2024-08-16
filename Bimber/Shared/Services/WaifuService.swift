//
//  WaifuService.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 7/27/24.
//

import Foundation

class WaifuService {
    private let baseUrl = "https://api.waifu.im"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func makeRequest(for endpoint: String, queryItems: [URLQueryItem] = [], completion: @escaping (Result<Data, Error>) -> Void) {
        var components = URLComponents(string: baseUrl + endpoint)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    private func decode<T: Decodable>(_ data: Data, to type: T.Type) -> Result<T, Error> {
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func search(query: String, offset: Int,limit: Int, completion: @escaping (Result<TrendingGifsModel, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
        ]
        
        makeRequest(for: "/gifs/search", queryItems: queryItems) { result in
            switch result {
            case .success(let data):
                completion(self.decode(data, to: TrendingGifsModel.self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
