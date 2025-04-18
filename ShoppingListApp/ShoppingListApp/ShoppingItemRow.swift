import SwiftUI

struct ShoppingItemRow: View {
    let item: ShoppingItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name ?? "Unknown Item")
                    .font(.headline)
                Text("Category: \(item.category ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("$\(item.totalPrice, specifier: "%.2f")")
                    .font(.headline)
                Text("Qty: \(item.quantity)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
