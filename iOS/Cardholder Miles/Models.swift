import Foundation

struct Entry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var programName: String
    var programType: String
    var balance: Double
    var expiryDays: Double
    var date: Date = Date()
    var notes: String = ""
}
