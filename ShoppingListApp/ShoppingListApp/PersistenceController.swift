import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ShoppingMedal") // ✅ Use your Core Data model name
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data Load Error: \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // ✅ Get the Core Data context
    var context: NSManagedObjectContext {
        return container.viewContext
    }

    // ✅ Save data to Core Data
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // ✅ Delete an object from Core Data
    func delete(_ object: NSManagedObject) {
        let context = container.viewContext
        context.delete(object)
        save()
    }

    // ✅ Fetch all shopping items from Core Data
    func fetchShoppingItems() -> [ShoppingItem] {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching ShoppingItems: \(error.localizedDescription)")
            return []
        }
    }

    // ✅ Fetch all shopping groups from Core Data
    func fetchShoppingGroups() -> [ShoppingGroup] {
        let request: NSFetchRequest<ShoppingGroup> = ShoppingGroup.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching ShoppingGroups: \(error.localizedDescription)")
            return []
        }
    }
}
