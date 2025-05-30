import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T
    let error: String?
}