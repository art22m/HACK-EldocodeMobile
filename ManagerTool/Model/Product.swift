//
//  Product.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import Foundation

protocol IProduct: class {
    var vendorCode: String? { get set }
    var price: String? { get set }
    var name: String? { get set }
    var pictureURL: String? { get set }
    var productURL: String { get set }
}

class Product: IProduct {
    var vendorCode: String?
    var price: String?
    var name: String?
    var pictureURL: String?
    var productURL: String
    
    init (vendorCode: String?, name: String?, price: String?, pictureURL: String?, productURL: String) {
        self.vendorCode = vendorCode
        self.price = price
        self.name = name
        self.pictureURL = pictureURL
        self.productURL = productURL
    }
}
