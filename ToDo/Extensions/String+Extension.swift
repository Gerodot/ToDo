//
//  String+Extension.swift
//  ToDo
//
//  Created by Gerodot on 5/16/22.
//

extension String {
    var capitalizedWithSpaces: String {
        let withSpaces = reduce("") { result, character in character.isUppercase ? "\(result) \(character)" : "\(result)\(character)" }

        return withSpaces.capitalized
    }
}
