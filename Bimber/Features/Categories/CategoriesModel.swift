import Foundation

// MARK: - CategoriesResponse
struct CategoriesResponse: Codable {
    let data: [Categories]?
    let pagination: Pagination?
    let meta: Meta?
}

// MARK: - Datum
struct Categories: Codable {
    let name, nameEncoded: String?
    let subcategories: [Subcategory]?
    let gif: GifModel

    enum CodingKeys: String, CodingKey {
        case name
        case nameEncoded = "name_encoded"
        case subcategories
        case gif
    }
}

// MARK: - Subcategory
struct Subcategory: Codable {
    let name, nameEncoded: String?

    enum CodingKeys: String, CodingKey {
        case name
        case nameEncoded = "name_encoded"
    }
}
