import SwiftUI
import CoreData

struct GroupsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // ✅ Fetch Core Data Shopping Groups
    @FetchRequest(
        entity: ShoppingGroup.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingGroup.name, ascending: true)]
    ) private var groups: FetchedResults<ShoppingGroup>

    var shoppingList: [ShoppingItem]
    @State private var newGroupName = ""
    @State private var showAddGroupAlert = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groups, id: \.self) { group in
                        NavigationLink(destination: GroupDetailView(
                            group: group,
                            items: shoppingList.filter { $0.group == group } // ✅ Filter correctly
                        )) {
                            HStack {
                                Text(group.name ?? "Unnamed Group") // ✅ Fix Optional
                                    .font(.headline)
                                Spacer()
                                Text("Total: $\(group.totalCost, specifier: "%.2f")")
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

    // ✅ Function to Add a New Group in Core Data
    private func addGroup() {
        guard !newGroupName.isEmpty else { return }
        
        let newGroup = ShoppingGroup(context: viewContext) // ✅ Use Core Data Context
        newGroup.id = UUID()
        newGroup.name = newGroupName

        try? viewContext.save() // ✅ Save to Core Data
        newGroupName = ""
    }

    // ✅ Function to Delete a Group in Core Data
    private func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            let group = groups[index]
            viewContext.delete(group)
        }
        try? viewContext.save()
    }
}

#Preview {
    GroupsView(shoppingList: [])
        .environment(\.managedObjectContext, PersistenceController.shared.context) // ✅ Fix Preview
}
