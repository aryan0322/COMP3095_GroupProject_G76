import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // ✅ Fetch Shopping Items from Core Data
    @FetchRequest(
        entity: ShoppingItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.name, ascending: true)]
    ) private var shoppingList: FetchedResults<ShoppingItem>

    // ✅ Fetch Shopping Groups from Core Data
    @FetchRequest(
        entity: ShoppingGroup.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingGroup.name, ascending: true)]
    ) private var groups: FetchedResults<ShoppingGroup>

    @State private var showAddItemScreen = false
    @State private var showGroupsScreen = false // ✅ New state for GroupsView modal
    @State private var editingItem: ShoppingItem? // Stores the item being edited

    var totalCost: Double {
        shoppingList.reduce(0) { $0 + $1.totalPrice }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    // ✅ Display Groups Section
                    groupsSection()

                    // ✅ Display Shopping Items Section
                    shoppingItemsSection()
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
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // ✅ Folder Icon to Open GroupsView (Fixed Error)
                    Button(action: {
                        showGroupsScreen.toggle()
                    }) {
                        Image(systemName: "folder")
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
            .sheet(isPresented: $showGroupsScreen) {
                GroupsView(shoppingList: Array(shoppingList)) // ✅ Convert FetchedResults to Array
            }
            .sheet(isPresented: $showAddItemScreen) {
                AddEditItemView(
                    itemToEdit: editingItem,
                    groups: Array(groups), // ✅ Convert FetchedResults to Array
                    context: viewContext,
                    onSave: { try? viewContext.save() }
                )
            }
        }
    }

    // ✅ Groups Section
    @ViewBuilder
    private func groupsSection() -> some View {
        if !groups.isEmpty {
            Section(header: Text("Item Groups")) {
                ForEach(groups, id: \.self) { group in
                    NavigationLink(destination: GroupDetailView(group: group, items: shoppingList.filter { $0.group == group })) { // ✅ Pass items
                        HStack {
                            Text(group.name ?? "Unnamed Group")
                                .font(.headline)
                            Spacer()
                            Text("Total: $\(group.totalCost, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }

    // ✅ Shopping Items Section
    @ViewBuilder
    private func shoppingItemsSection() -> some View {
        Section(header: Text("Shopping List")) {
            ForEach(shoppingList, id: \.self) { item in
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
    }

    // ✅ Delete Shopping Item from Core Data
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = shoppingList[index]
            viewContext.delete(item)
        }
        try? viewContext.save()
    }

    private func subtotal() -> Double {
        shoppingList.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    private func totalTax() -> Double {
        shoppingList.reduce(0) { $0 + ($1.tax * Double($1.quantity)) }
    }
}
