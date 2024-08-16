//
//  SearchAutocompleteModel.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 7/27/24.
//

import Foundation

// MARK: - CategoriesResponse
struct SearchAutocompleteResponse: Codable {
    let data: [SearchAutocomplete]?
    let meta: Meta?
    let pagination: Pagination?
}

// MARK: - Datum
struct SearchAutocomplete: Codable {
    let name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}
