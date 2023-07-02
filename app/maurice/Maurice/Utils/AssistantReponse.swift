import Foundation

struct AssistantReponse: Decodable {
    var message: Message
    var total_requests_count: Int
}
