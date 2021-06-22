//
//  SendActions.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import Foundation
import Firebase

protocol ISaveActions: class {
    func saveProducts(products: [Product], manager: String, customerPhone: String?)
}

class SaveActions: ISaveActions {
    private lazy var db = Firestore.firestore()
    
    func saveProducts(products: [Product], manager: String, customerPhone: String?) {
        let productsLinkAndName = products.map { ["name" : $0.name ?? "Имя недоступно", "link" : $0.productURL] }
        print(productsLinkAndName.description)
        let id = "staffID12345"
        db.collection("carts").addDocument(data: ["client_ref": db.document("/clients/\(customerPhone ?? "Незивестен")"), "datetime" : Date.init(), "products" : productsLinkAndName, "staff_ref": db.document("/staff/\(id)")])
    }
    
    
}
