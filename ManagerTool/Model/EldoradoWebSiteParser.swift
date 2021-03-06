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
    let barcodeDB : [String : String] = ["8806084563057" : "https://www.eldorado.ru/cat/detail/71346007/?utm_a=A670"]
    private func getHTMLDocument(from URLString: String) -> Document? {
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
    
    func getProductData(from URLString: String) -> (name: String?, vendorCode: String?, price: String?, pictureURL: String?, productURL: String) {
        let doc = getHTMLDocument(from: URLString)
        guard doc != nil else { return (name: nil, vendorCode: nil, price: nil, pictureURL: nil, productURL: URLString) }
        
        var productNameString: String? = nil
        var productPriceString: String? = nil
        var productPictureURLString: String? = nil
        var productVendorCodeString: String? = nil
        
        do {
//            let productNameString = try doc?.select("div.i-flocktory").first()?.attr("data-fl-item-name")
//            print(productNameString)
            let productNameDoc = try doc?.select("h1.catalogItemDetailHd").first()
            do {
                productNameString = try productNameDoc?.text()
            }
        } catch let error {
            print("Error with name: \(error)")
        }
        
        do {
            productPriceString = try doc?.select("div.i-flocktory").first()?.attr("data-fl-item-price")
//            print(productPriceString)
        } catch let error {
            print("Error with price: \(error)")
        }
        
        do {
            productPictureURLString = try doc?.select("div.i-flocktory").first()?.attr("data-fl-item-picture")
//            print(productPictureURLString)
        } catch let error {
            print("Error with image: \(error)")
        }
                
        do {
            productVendorCodeString = try doc?.select("div.i-flocktory").first()?.attr("data-fl-item-id")
//            print(productVendorCodeString)
        } catch let error {
            print("Error with image: \(error)")
        }
        
        return (name: productNameString, vendorCode: productVendorCodeString, price: productPriceString, pictureURL: productPictureURLString, productURL: URLString)
    }
    
    
    func getURLByBarcode(barcode: String) -> String? {
        if (barcodeDB[barcode] != nil) {
            return barcodeDB[barcode]
        } else {
            return nil
        }
    }
}
