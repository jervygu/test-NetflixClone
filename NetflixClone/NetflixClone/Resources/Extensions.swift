//
//  Extensions.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import Foundation


extension String {
    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
