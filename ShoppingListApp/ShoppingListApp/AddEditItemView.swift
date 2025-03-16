import SwiftUI
import CoreData

struct AddEditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    let context: NSManagedObjectContext
    var itemToEdit: ShoppingItem? // ✅ Core Data Object
    var groups: [ShoppingGroup] // ✅ List of Groups
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var quantity: String = "1"
    @State private var selectedCategory: String = "Grocery"
    @State private var selectedGroup: ShoppingGroup? // ✅ Stores selected Core Data group

    let categories = ["Grocery", "Electronics", "Clothing", "Household"]
    var onSave: (() -> Void)? // ✅ Optional onSave Callback

    init(itemToEdit: ShoppingItem?, groups: [ShoppingGroup], context: NSManagedObjectContext, onSave: (() -> Void)? = nil) {
        self.context = context
        self.itemToEdit = itemToEdit
        self.groups = groups
        self.onSave = onSave

        _name = State(initialValue: itemToEdit?.name ?? "")
        _price = State(initialValue: itemToEdit?.price.description ?? "")
        _quantity = State(initialValue: itemToEdit?.quantity.description ?? "1")
        _selectedCategory = State(initialValue: itemToEdit?.category ?? "Grocery")
        _selectedGroup = State(initialValue: itemToEdit?.group) // ✅ Assign Core Data group
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
                    Picker("Select Group", selection: $selectedGroup) {
                        Text("None").tag(nil as ShoppingGroup?)
                        ForEach(groups, id: \.self) { group in
                            Text(group.name ?? "Unnamed Group").tag(group as ShoppingGroup?)
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
        let item = itemToEdit ?? ShoppingItem(context: context) // ✅ Use Core Data object
        item.id = item.id ?? UUID()
        item.name = name
        item.price = Double(price) ?? 0.0
        item.quantity = Int64(quantity) ?? 1
        item.category = selectedCategory
        item.tax = calculatedTax
        item.group = selectedGroup // ✅ Assign selected group to Core Data

        try? context.save() // ✅ Save changes to Core Data
        onSave?() // ✅ Call the onSave function if provided
        presentationMode.wrappedValue.dismiss()
    }
}
