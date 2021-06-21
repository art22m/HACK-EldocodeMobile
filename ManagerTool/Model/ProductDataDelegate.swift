//
//  ProductDataDelegate.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import Foundation


protocol ProductDataDelegate: class {
    func update(name: String?, vendorCode: String?, price: String?, pictureURL: String?)
}
