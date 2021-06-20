//
//  BasketCellModel.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import Foundation
import UIKit

protocol BasketCellConfiguration: class {
    var vendorCode: String { get set }
    var name: String? { get set }
    var logo: UIImage? { get set }
}

class BasketCellPattern: BasketCellConfiguration {
    var vendorCode: String
    var name: String?
    var logo: UIImage?
    
    init (vendorCode: String, name: String?, logo: UIImage?) {
        self.vendorCode = vendorCode
        self.name = name
        self.logo = logo
    }
}
