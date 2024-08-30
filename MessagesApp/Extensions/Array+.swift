//
//  Array+.swift
//  MessagesApp
//
//  Created by Sergii Tkachenko on 30.08.2024.
//

import Foundation

public extension Array {
    
    mutating func shuffle() {
        guard count > 0 else {
            return
        }

        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if j != i {
                self.swapAt(i, j)
            }
        }
    }
    
    func shuffled() -> [Element] {
        var list = self
        list.shuffle()
        return list
    }
    
    func random() -> Element? {
        return (count > 0) ? self.shuffled()[0] : nil
    }
    
    func random(_ count: Int = 1) -> [Element] {
        let result = shuffled()
        return (count > result.count) ? result : Array(result[0..<count])
    }
}
