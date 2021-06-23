//
//  SendActions.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import Foundation
import Firebase

protocol ISaveActions: class {
    func saveProducts(products: [Product], managerID: String, customerPhone: String) -> String
}

class SaveActions: ISaveActions {
    private lazy var db = Firestore.firestore()
    
    func saveProducts(products: [Product], managerID: String, customerPhone: String) -> String {
        guard products.isEmpty == false else { return "cartIsEmpty" }
        
        let productsLinkAndName = products.map { ["name" : $0.name ?? "empty", "link" : $0.productURL] }
        
        // Добавляет документ в коллекцию carts, присваивая ссылку на документ
        let docRef = db.collection("carts").addDocument(data: ["client_ref": db.document("/clients/\(customerPhone)"), "datetime" : Date.init(), "products" : productsLinkAndName, "staff_ref": db.document("/staff/\(managerID)")])
        print(docRef.documentID)
        
        db.collection("staff").document(managerID).updateData(["ref" : FieldValue.arrayUnion([docRef])])
        
        return docRef.documentID
    }
}
