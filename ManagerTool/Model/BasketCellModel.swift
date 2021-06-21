//
//  BasketCellModel.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import Foundation
import UIKit

protocol BasketCellConfiguration: class {
    var vendorCode: String? { get set }
    var price: String? { get set }
    var name: String? { get set }
    var pictureURL: String? { get set }
}

class BasketCellPattern: BasketCellConfiguration {
    var vendorCode: String?
    var price: String?
    var name: String?
    var pictureURL: String?
    
    init (vendorCode: String?, name: String?, price: String?, pictureURL: String?) {
        self.vendorCode = vendorCode
        self.price = price
        self.name = name
        self.pictureURL = pictureURL
    }
}
