import SwiftUI

struct AddEditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var name: String
    @State var price: String
    @State var quantity: String
    @State var selectedCategory: String
    @State var selectedGroupId: UUID? // Stores selected group

    let categories = ["Grocery", "Electronics", "Clothing", "Household"]
    var groups: [ShoppingGroup] // List of groups
    var onSave: (ShoppingItem) -> Void
    var itemToEdit: ShoppingItem?

    init(itemToEdit: ShoppingItem?, groups: [ShoppingGroup], onSave: @escaping (ShoppingItem) -> Void) {
        self.onSave = onSave
        self.groups = groups
        self.itemToEdit = itemToEdit

        _name = State(initialValue: itemToEdit?.name ?? "")
        _price = State(initialValue: itemToEdit?.price.description ?? "")
        _quantity = State(initialValue: itemToEdit?.quantity.description ?? "1")
        _selectedCategory = State(initialValue: itemToEdit?.category ?? "Grocery")
        _selectedGroupId = State(initialValue: itemToEdit?.groupId)
    }

    var calculatedTax: Double {
        let priceValue = Double(price) ?? 0.0
        let taxRate = selectedCategory == "Electronics" ? 0.15 :
                      selectedCategory == "Clothing" ? 0.10 :
                      selectedCategory == "Household" ? 0.08 : 0.05
        return priceValue * taxRate
    }

    var totalPrice: Double {
        let priceValue = Double(price) ?? 0.0
        let qty = Int(quantity) ?? 1
        return (priceValue * Double(qty)) + calculatedTax
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $name)
                    TextField("Price", text: $price).keyboardType(.decimalPad)
                    TextField("Quantity", text: $quantity).keyboardType(.numberPad)
                }

                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Assign to Group")) {
                    Picker("Select Group", selection: $selectedGroupId) {
                        Text("None").tag(UUID?.none) // No group
                        ForEach(groups) { group in
                            Text(group.name).tag(group.id as UUID?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Summary")) {
                    Text("Tax: $\(calculatedTax, specifier: "%.2f")")
                    Text("Total Price: $\(totalPrice, specifier: "%.2f")").font(.headline)
                }
            }
            .navigationTitle(itemToEdit == nil ? "Add Item" : "Edit Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveItem() }
                }
            }
        }
    }

    func saveItem() {
        let newItem = ShoppingItem(
            id: itemToEdit?.id ?? UUID(),
            name: name,
            price: Double(price) ?? 0.0,
            quantity: Int(quantity) ?? 1,
            category: selectedCategory,
            tax: calculatedTax,
            groupId: selectedGroupId // ✅ Updates the group ID
        )

        onSave(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}
