import Foundation

struct ShoppingItem: Identifiable {
    let id: UUID
    var name: String
    var price: Double
    var quantity: Int
    var category: String
    var tax: Double
    var groupId: UUID?

    var totalPrice: Double {
        (price * Double(quantity)) + (tax * Double(quantity))
    }
}
