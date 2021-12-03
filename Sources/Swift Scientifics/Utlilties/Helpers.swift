//
//  File.swift
//  
//
//  Created by Hunter Holland on 12/1/21.
//

// MARK: Helper Functions
extension Array where Element == Int {
    var product: Int {
        self.reduce(1, *)
    }
}

extension UnsafeMutableBufferPointer where Element: Numeric {
    
    /// Allocates a buffer with the given size. Wrapper around ``UnsafeMutableBufferPointer.allocate``.
    /// - Parameters:
    ///   - count: The number of elements in the buffer.
    /// - Returns: UnsafeMutableBufferPointer
    static func malloc(count: Int) -> UnsafeMutableBufferPointer {
        let buffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: count)
        
        return buffer
    }
    
    /// Allocates and initializes a buffer with the given size and value.
    /// - Parameters:
    ///   - count: The number of elements in the buffer.
    ///   - value: The value of each elements in the initialized buffer.
    /// - Returns: UnsafeMutableBufferPointer
    static func calloc(count: Int, value: Element) -> UnsafeMutableBufferPointer {
        let buffer = UnsafeMutableBufferPointer<Element>.malloc(count: count)
        buffer.assign(repeating: value)
        
        return buffer
    }
}

// MARK: Undefined
func undefined<T>(_ message: String = "") -> T {
    fatalError("Undefined: \(message)")
}
