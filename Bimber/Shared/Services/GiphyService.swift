import Foundation

class GiphyService {
    private let apiKey = "rO3pj0Wn3VSweN6OjIbwoqPvuD3x7Pfm"
    private let baseUrl = "https://api.giphy.com/v1"
    private let rating = "r"
    private let bundle = "messaging_non_clips"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func makeRequest(for endpoint: String, queryItems: [URLQueryItem] = [], completion: @escaping (Result<Data, Error>) -> Void) {
        var components = URLComponents(string: baseUrl + endpoint)!
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)] + queryItems
        
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
    
    func getTrendingGifs(offset: Int, limit: Int, completion: @escaping (Result<TrendingGifsModel, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "rating", value: rating),
            URLQueryItem(name: "bundle", value: bundle)
        ]
        
        makeRequest(for: "/gifs/trending", queryItems: queryItems) { result in
            switch result {
            case .success(let data):
                completion(self.decode(data, to: TrendingGifsModel.self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func search(query: String, offset: Int,limit: Int, completion: @escaping (Result<TrendingGifsModel, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "rating", value: rating),
            URLQueryItem(name: "bundle", value: bundle),
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
    
    func searchAutocomplete(query: String, completion: @escaping (Result<SearchAutocompleteResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "offset", value: "0"),
        ]
        
        makeRequest(for: "/gifs/search/tags", queryItems: queryItems) { result in
            switch result {
            case .success(let data):
                completion(self.decode(data, to: SearchAutocompleteResponse.self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCategories(completion: @escaping (Result<CategoriesResponse, Error>) -> Void) {
        makeRequest(for: "/gifs/categories") { result in
            switch result {
            case .success(let data):
                completion(self.decode(data, to: CategoriesResponse.self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
