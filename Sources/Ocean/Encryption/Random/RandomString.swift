//
//  RandomString.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/30.
//

extension String {

    private static let printableCharacters = (33 ... 126)
        .map(UnicodeScalar.init)
        .map(String.init(_:))

    /// [Ocean] Generate a random printable string.
    /// - Parameter count: length of generating string.
    public static func randomPrintableString(count: Int) -> String {
        
        let characterIterator = AnyIterator<String> {

            return printableCharacters.randomElement()
        }
        
        let randomCharacters = (0 ..< count).map { _ in
            
            characterIterator.next()!
        }
        
        return randomCharacters.reduce("", +)
    }
}
