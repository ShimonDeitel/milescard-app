import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var categoryFilters: [String: Bool] = ["All": true]

    // Free tier limit. Seed data is well below this so a fresh install never hits the paywall.
    static let freeLimit = 5

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("Cardholder Miles_entries.json")
    }()

    init() {
        load()
        if entries.isEmpty {
            seed()
            save()
        }
    }

    func seed() {
        entries = [
            Entry(programName: "Sample A", programType: "Sample B", balance: 12, expiryDays: 3, notes: "First sample entry"),
        ]
    }

    var canAddMore: Bool {
        entries.count < Store.freeLimit
    }

    func add(_ entry: Entry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: Entry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: Entry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
