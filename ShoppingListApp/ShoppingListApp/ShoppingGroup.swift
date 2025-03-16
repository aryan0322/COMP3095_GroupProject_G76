import Foundation

struct ShoppingGroupModel: Identifiable {
    let id: UUID = UUID()
    var name: String
    var items: [ShoppingItem] // List of items in this group

    func totalCost() -> Double {
        items.reduce(into: 0) { $0 += $1.totalPrice }
    }
}
