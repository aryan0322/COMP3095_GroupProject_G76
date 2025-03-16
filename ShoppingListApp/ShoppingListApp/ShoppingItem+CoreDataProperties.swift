import Foundation
import CoreData

extension ShoppingItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int64
    @NSManaged public var category: String?
    @NSManaged public var tax: Double
    @NSManaged public var group: ShoppingGroup?
    
    public var totalPrice: Double {
        return (price * Double(quantity)) + tax
    }
}

extension ShoppingItem: Identifiable {}
