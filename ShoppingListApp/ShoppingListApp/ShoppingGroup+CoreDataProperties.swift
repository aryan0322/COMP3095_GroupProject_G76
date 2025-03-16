import Foundation
import CoreData

extension ShoppingGroup {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingGroup> {
        return NSFetchRequest<ShoppingGroup>(entityName: "ShoppingGroup")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var items: NSSet?
    
    public var totalCost: Double {
        let itemList = items as? Set<ShoppingItem> ?? []
        return itemList.reduce(0) { $0 + $1.totalPrice}
    }
}

// MARK: Generated accessors for items
extension ShoppingGroup {
    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ShoppingItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ShoppingItem)
}
