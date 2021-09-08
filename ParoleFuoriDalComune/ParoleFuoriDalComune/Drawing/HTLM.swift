//
//  HTLM.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 08/09/21.
//

import Foundation

struct HTML {
    
    func getIndex() -> String? {
        let stringURL = "http://www.intratext.com/ixt/ita0191/_STAT.HTM"

        guard let url = URL(string: stringURL) else {
            return nil
        }
        
        return try? String(contentsOf: url, encoding: .ascii)
    }
}
