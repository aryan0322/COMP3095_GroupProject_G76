import SwiftUI

struct GroupDetailView: View {
    var group: ShoppingGroup
    var items: [ShoppingItem] // ✅ Accepts only assigned items

    var body: some View {
        List {
            if items.isEmpty {
                Text("No items assigned to this group.")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                ForEach(items) { item in
                    ShoppingItemRow(item: item) // ✅ Show assigned items
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(group.name)
    }
}

#Preview {
    GroupDetailView(group: ShoppingGroup(name: "Example Group", items: []), items: [])
}
