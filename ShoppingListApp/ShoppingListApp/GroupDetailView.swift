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
                ForEach(items, id: \.self) { item in // ✅ Fix ForEach
                    ShoppingItemRow(item: item)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(group.name ?? "Unnamed Group") // ✅ Fix Optional String
    }
}

#Preview {
    let exampleGroup = ShoppingGroup(context: PersistenceController.shared.context)
    exampleGroup.id = UUID()
    exampleGroup.name = "Example Group"

    return GroupDetailView(group: exampleGroup, items: [])
}
