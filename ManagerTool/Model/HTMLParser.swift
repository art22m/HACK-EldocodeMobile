//
//  HTMLParser.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import Foundation
import Ji
import SwiftSoup

class EldoradoWebSiteParser {
    func getHTMLDocument(from URLString: String) -> Document? {
        var URLString = URLString
        
        // IF QR Code doesn't contain https protocol
        if (URLString.first != "h") {
            print(URLString)
            URLString.insert(contentsOf: "https://", at: URLString.startIndex)
        }
        
        if let checkedURLString = URL(string: URLString) {
            let jiDoc = Ji(htmlURL: checkedURLString)
            do {
                let doc = try SwiftSoup.parse(jiDoc?.description ?? "")
                return doc
            } catch let error {
                print("Error with parsing: \(error)")
                return nil
            }
        } else {
            print("Invalid url: \(URLString)")
            return nil
        }
    }
    
    func getProductData(from URLString: String) -> (name: String?, price: String?, picture: UIImage?) {
        let doc = getHTMLDocument(from: URLString)
        guard doc != nil else { return (name: nil, price: nil, picture: nil) }
        
        do {
            let productNameString = try doc?.select("div.i-flocktory").first()?.attr("data-fl-item-name")
//            print(productNameString)
//            let productNameDoc = try doc?.select("h1.catalogItemDetailHd").first()
//            do {
//                let productNameString = try productNameDoc?.text()
//            }
        } catch let error {
            print("Error with name: \(error)")
        }
        
        do {
            let productPriceString = try doc?.select("div.i-flocktory").first()?.attr("data-fl-item-price")
//            print(productPriceString)
        } catch let error {
            print("Error with price: \(error)")
        }
        
        do {
            let productPictureURLString = try doc?.select("div.i-flocktory").first()?.attr("data-fl-item-picture")
//            print(productPictureURLString)
        } catch let error {
            print("Error with image: \(error)")
        }
        
        return(nil, nil, nil)
    }
}
