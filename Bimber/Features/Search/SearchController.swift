//
//  SearchPageController.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 7/27/24.
//

import Foundation
import Combine

class SearchController: ObservableObject {
    @Published var autocomplete: [SearchAutocomplete] = []
    @Published var query: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let giphyService = GiphyService()
    
    init() {
        $query
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard !query.isEmpty else {
                    self?.cleanProposals()
                    return
                }
                self?.getAutocompleteForQuery(query: query)
            }
            .store(in: &cancellables)
    }
    
    func cleanProposals(){
        self.autocomplete = []
    }
    
    func getAutocompleteForQuery(query: String) {
        giphyService.searchAutocomplete(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let searchAutocomplete = response.data {
                        self?.autocomplete = searchAutocomplete
                    } else {
                        print("No data found")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Failed to fetch gifs: \(error.localizedDescription)")
                }
            }
        }
    }
}
