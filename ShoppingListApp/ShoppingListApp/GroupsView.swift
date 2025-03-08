import SwiftUI

struct GroupsView: View {
    @State private var groups: [ShoppingGroup] = [
        ShoppingGroup(name: "Groceries", items: []),
        ShoppingGroup(name: "Electronics", items: [])
    ]
    
    @Binding var shoppingList: [ShoppingItem]
    
    @State private var newGroupName = ""
    @State private var showAddGroupAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groups) { group in
                        NavigationLink(destination: GroupDetailView(group: group, items: shoppingList.filter{$0.groupId == group.id})) {
                            HStack {
                                Text(group.name)
                                    .font(.headline)
                                Spacer()
                                Text("Total: $\(group.totalCost(), specifier: "%.2f")")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteGroup)
                }
                .listStyle(InsetGroupedListStyle())
                
                Button(action: { showAddGroupAlert = true }) {
                    Text("Add New Group")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .alert("New Group", isPresented: $showAddGroupAlert, actions: {
                    TextField("Enter Group Name", text: $newGroupName)
                    Button("Add", action: addGroup)
                    Button("Cancel", role: .cancel, action: {})
                })
            }
            .navigationTitle("Item Groups")
        }
    }

    // Function to Add a New Group
    private func addGroup() {
        guard !newGroupName.isEmpty else { return }
        groups.append(ShoppingGroup(name: newGroupName, items: []))
        newGroupName = ""
    }

    // Function to Delete a Group
    private func deleteGroup(at offsets: IndexSet) {
        groups.remove(atOffsets: offsets)
    }
    
}

#Preview {
    GroupsView(shoppingList: .constant([]))
}
