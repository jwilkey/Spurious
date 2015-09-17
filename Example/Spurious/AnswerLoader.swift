import Foundation

public protocol AnswerLoader {
    func fetchTheAnswer() -> String
    func sendTheResponse(response: String, count: Int)
}
