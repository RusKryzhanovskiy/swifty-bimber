import Foundation
import Combine

class TrandingGifsController: ObservableObject {
    @Published var gifs: [GifModel] = []
    @Published var isLoading: Bool = false
    
    private var currentPage = 0
    private let limit = 50
    
    private let giphyService = GiphyService()
    
    func fetchGifs(loadMore: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        
        let offset = currentPage * limit
        giphyService.getTrendingGifs(offset: offset,limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let fetchedGifs = response.data {
                        self?.gifs.append(contentsOf: fetchedGifs)
                        self?.currentPage += 1
                        
                    } else {
                        print("No data found")
                    }
                case .failure(let error):
                    print("Failed to fetch gifs: \(error.localizedDescription)")
                }
                self?.isLoading = false
            }
        }
    }
}
