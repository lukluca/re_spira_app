//
//  HTLM.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 08/09/21.
//

import Foundation

struct HTML {
    
    private let root = "http://www.intratext.com/ixt/ita0191/"
    
    enum HTMLError: Error {
        case notAnURL
    }
    
    func getIndex() throws -> String {
        try getPage(at: "_STAT.HTM")
    }
    
    func getPage(at path: String) throws -> String {
        let stringURL = root + path

        guard let url = URL(string: stringURL) else {
            throw HTMLError.notAnURL
        }
        
        return try String(contentsOf: url, encoding: .ascii)
    }
}

import SwiftSoup

struct HTMLParser {
    
    enum HTMLParserError: Error {
        case noTableAtPosition(Int)
    }
    
    struct DistributionLink {
        let href: String
        let range: [Int]
    }
    
    struct WordLink {
        let href: String
        let word: String
        let frequency: Int
    }
    
    func extractDrawModels(from href: String, using word: String) throws -> [DrawModel] {
        let page = try getPage(from: href)
        let table = try extractTable(from: page, at: 2)
        
        let text = try table.text()
        
        let purifiedText = Substring(text).deletingPrefix("Parte, Capitolo, Capoverso")

        let splitted = purifiedText.split(separator: "\n")
        
        let dropped: AnyCollection<Substring>
        if splitted.first == " " {
            dropped = AnyCollection(splitted.dropFirst())
        } else {
            dropped = AnyCollection(splitted)
        }
        
        return dropped.compactMap { val -> DrawModel? in
            let values = val.split(separator: "|")
            let rights = values.first?.split(separator: ",")

            let first = rights?.first
            let middle = rights?[1]
            let last = rights?.last
            
            if let rangeCanto = middle?.rangeOfCharacter(from: .decimalDigits),
               let canto = middle?[rangeCanto],
               let intCanto = Int(canto),
               let rangeVerso = last?.rangeOfCharacter(from: .decimalDigits),
               let verso = last?[rangeVerso],
               let intVerso = Int(verso) {
                
                if first?.contains("In") == true {
                    return DrawModel(cantica: .inferno, canto: intCanto, verso: intVerso, word: word)
                }
                if first?.contains("Pu") == true {
                    return DrawModel(cantica: .purgatorio, canto: intCanto, verso: intVerso, word: word)
                }
                if first?.contains("Pa") == true {
                    return DrawModel(cantica: .paradiso, canto: intCanto, verso: intVerso, word: word)
                }
            }
            return nil
        }
    }
    
    func extractWordLinks(from href: String) throws -> [WordLink] {
        let page = try getPage(from: href)
        let table = try extractTable(from: page, at: 3)
        
        let td = try table.select("td").first()
        
        let text = try td?.text() ?? ""
        
        let texts = text.split(separator: "\n").dropFirst()
        
        let mapped = texts.map { string -> [Substring] in
            let delete = string.deletingPrefix("  ")
            return delete.split(separator: " ")
        }

        let elements = try table.select("a")
        
        
        let links = try elements.compactMap { element -> WordLink? in
            guard let href = try? element.attr("href") else {
                return nil
            }
            let text = try element.text()
            
            let found = mapped.first {
                $0.contains(Substring(text))
            }
            
            guard let value = found?.first, let frequency = Int(value) else {
                return nil
            }
            
            return WordLink(href: href, word: text, frequency: frequency)
        }
        
        return links
    }
    
    
    func extractDistributionsLinks() throws -> [DistributionLink] {
        let index = try HTML().getIndex()
        let table = try extractTable(from: index, at: 5)
        
        return try table.select("tr").compactMap { tr -> DistributionLink? in
            let tds: Elements = try tr.select("td")
            
            let td = tds.first()
            guard let href = try td?.select("a").first()?.attr("href"),
                  let text = try td?.text() else {
                return nil
            }
            
            let splitted = text.split(separator: "-")
            
            if splitted.count == 2 {
                let first = splitted[0]
                let last = splitted[1]
                
                let val1 = Int(first) ?? 0
                let val2 = Int(last) ?? 0
                return DistributionLink(href: href, range: [val1, val2].sorted())
            } else {
                let val = Int(text) ?? 0
                return DistributionLink(href: href, range: [val])
            }
        }
    }
    
    private func getPage(from href: String) throws -> String {
        try HTML().getPage(at: href)
    }
    
    private func extractTable(from html: String, at position: Int) throws -> Elements.Element {
        let doc: Document = try SwiftSoup.parse(html)
        let tables: Elements = try doc.getElementsByTag("table")
        guard tables.count > position else {
            throw HTMLParserError.noTableAtPosition(position)
        }
        return tables.get(position)
    }
}

private extension Substring {
    func deletingPrefix(_ prefix: String) -> Substring {
        guard self.hasPrefix(prefix) else { return self }
        return self.dropFirst(prefix.count)
    }
}
