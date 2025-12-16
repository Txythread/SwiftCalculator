//
//  LanguageString.swift
//  Calculator
//
//  Created by Michael Rudolf on 16.12.25.
//

import Foundation


struct Language: Codable {
    static let LANGUAGE: String = ""
    static let REGION: String = "us"
    
    var comma: String
    
    public static func getLanguage() -> Language {
        let path = Bundle.main.path(forResource: REGION + ".json", ofType: nil)!
        
        let jsonReader = JSONDecoder()
        return try! jsonReader.decode(Language.self, from: Data(contentsOf: URL(filePath: path)))
    }
    
    
    
}
