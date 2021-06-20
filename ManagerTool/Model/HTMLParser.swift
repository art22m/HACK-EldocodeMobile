//
//  HTMLParser.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import Foundation

class HTMLParser {
    func getHTML(from URLString: String) -> String? {
        if let myURL = URL(string: URLString) {
            do {
                let contents = try String(contentsOf: myURL, encoding: .utf8)
                return contents
            } catch {
                print("Error : \(error)")
                return nil
            }
        } else {
            print("Error: \(URLString) doesn't  URL")
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
