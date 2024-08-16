import Foundation
import Combine

class CategoriesController: ObservableObject {
    @Published var categories: [Categories] = []
    
    private let giphyService = GiphyService()
    
    func fetchCategories() {
        giphyService.getCategories() { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let categories = response.data {
                        self?.categories = categories
                    } else {
                        print("No data found")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Failed to fetch categories: \(error.localizedDescription)")
                }
            }
        }
    }
}
