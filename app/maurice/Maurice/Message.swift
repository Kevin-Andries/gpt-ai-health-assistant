import Foundation

struct Message: Identifiable, Decodable {
    var id: UUID
    var user_id: String
    var author: String
    var message: String
    var created_at: String
}
