import SwiftUI
import Foundation

struct ContentView: View {
    @State private var shoppingList: [ShoppingItem] = [
        ShoppingItem(id: UUID(), name: "Milk", price: 3.99, quantity: 1, category: "Dairy", tax: 0.20),
        ShoppingItem(id: UUID(), name: "Bread", price: 2.50, quantity: 2, category: "Bakery", tax: 0.15),
        ShoppingItem(id: UUID(), name: "Apples", price: 5.00, quantity: 1, category: "Fruits", tax: 0.25)
    ]
    
    @State private var groups: [ShoppingGroup] = [
            ShoppingGroup(name: "Groceries", items: []),
            ShoppingGroup(name: "Electronics", items: [])
        ]
    
    @State private var showAddItemScreen = false
    @State private var editingItem: ShoppingItem? // Stores the item being edited

    var totalCost: Double {
        shoppingList.reduce(0) { $0 + ($1.totalPrice) }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(shoppingList) { item in
                        Button(action: {
                            editingItem = item // Set item for editing
                            showAddItemScreen = true
                        }) {
                            ShoppingItemRow(item: item)
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes button styling
                    }
                    .onDelete(perform: deleteItem)
                }
                .listStyle(InsetGroupedListStyle())

                VStack {
                    Text("Subtotal: $\(subtotal(), specifier: "%.2f")")
                    Text("Total Tax: $\(totalTax(), specifier: "%.2f")")
                    Text("Total Cost: $\(totalCost, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: GroupsView(shoppingList: $shoppingList)) {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editingItem = nil // Set to nil for new item
                        showAddItemScreen.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddItemScreen) {
                AddEditItemView(
                    itemToEdit: editingItem,
                    groups: groups,// Pass the selected item
                    onSave: { newItem in
                        if let index = shoppingList.firstIndex(where: { $0.id == newItem.id }) {
                            shoppingList[index] = newItem // Edit existing item
                        } else {
                            shoppingList.append(newItem) // Add new item
                        }
                        
                        updateGroups()
                    }
                )
            }
        }
    }

    private func updateGroups() {
        for i in groups.indices{
            groups[i].items = shoppingList.filter({$0.groupId == groups[i].id})
        }
    }
    
    private func subtotal() -> Double {
        shoppingList.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    private func totalTax() -> Double {
        shoppingList.reduce(0) { $0 + ($1.tax * Double($1.quantity)) }
    }

    private func deleteItem(at offsets: IndexSet) {
        shoppingList.remove(atOffsets: offsets)
    }
    
    struct ShoppingItemRow: View {
        let item: ShoppingItem

        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text("Category: \(item.category)")
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
}
