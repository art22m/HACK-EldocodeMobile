//
//  HTMLParser.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import Foundation
import Ji

class HTMLParser {
    func getHTML(from URLString: String) -> String? {
        var URLString = URLString
        if (URLString.first != "h") {
            print(URLString)
            URLString.insert(contentsOf: "https://", at: URLString.startIndex)
        }
        let myURL = URL(string: URLString)
        if let completeURL = myURL {
            let doc = Ji(htmlURL: completeURL)
            print(doc ?? "")
            return nil
        } else {
            print("Invalid url: \(URLString)")
            return nil
        }
    }
    
    func getArticul(from URLString: String) -> String {
        var articul: String = ""
        
        for c in URLString {
            if "0" <= c && c <= "9" {
               articul += String(c)
            } else if (articul.count != 0) {
                break
            }
        }
    
        return articul
    }
    
    func getURL(from articul: String) -> String {
        return "https://www.eldorado.ru/search/catalog.php?q=\(articul)&utf"
    }
}
