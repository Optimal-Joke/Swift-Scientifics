//
//  ndArray.swift
//
//
//  Created by Hunter Holland on 12/1/21.
//

import Foundation

public struct ndArray<T: Numeric>: MutableCollection {
    var shape: [Int]
    private var buffer: UnsafeMutableBufferPointer<T>
    
    // MARK: Initializers
    init(shape: [Int]) {
        self.shape = shape
        self.buffer = UnsafeMutableBufferPointer<T>.allocate(capacity: shape.reduce(1, *))
    }
    
    init(shape: [Int], repeating val: T) {
        self.shape = shape
        self.buffer = UnsafeMutableBufferPointer<T>.calloc(count: shape.product, value: val)
    }
    
    init(buffer: UnsafeMutableBufferPointer<T>) { // TODO: Add ability to pass shape parameter
        self.buffer = buffer
        self.shape = [1, buffer.count]
    }
    
    init(_ array: [T]) {
        self.buffer = UnsafeMutableBufferPointer<T>.malloc(count: array.count)
        _ = self.buffer.initialize(from: array)
        
        self.shape = [1, buffer.count]
    }
    
    // MARK: MutableCollection Conformance
    public typealias Index = Int
    public typealias Element = T
    
    public func index(after i: Self.Index) -> Self.Index {
        i + 1
    }
    
    public var startIndex: Self.Index {
        self.buffer.startIndex
    }
    
    public var endIndex: Self.Index {
        self.buffer.endIndex
    }
    
    public subscript(index: Self.Index) -> T {
        get {
            self.buffer[index]
        }
        set(newValue) {
            self.buffer[index] = newValue
        }
    }
}

extension ndArray: Equatable {
    /// Returns whether or not two `ndArray` objects are equal. Equality is determined based on array shape and element equality.
    /// - Returns: A boolean denoting the equality of the two arrays.
    public static func == (lhs: ndArray, rhs: ndArray) -> Bool {
        lhs.shape == rhs.shape && lhs.buffer.elementsEqual(rhs.buffer)
    }
}

// MARK: - Static Methods
extension ndArray {
    /// Return a new zero-filled array of the given shape.
    /// - Parameter shape: Shape of the new array.
    /// - Returns: Array of zeros with the given shape.
    public static func zeros(shape: [Int]) -> ndArray<Self.Element> {
        let value: Self.Element = 0
        
        return self.init(shape: shape, repeating: value)
    }
    
    /// Return a new one-filled array of the given shape.
    /// - Parameter shape: Shape of the new array.
    /// - Returns: Array of ones with the given shape.
    public static func ones(shape: [Int]) -> ndArray<Self.Element> {
        let value: Self.Element = 1
        
        return self.init(shape: shape, repeating: value)
    }
    
    /// Return an array of zeros with the same shape and type of input.
    /// - Parameter arr: The shape and data-type of `arr` define these same attributes of the returned array.
    /// - Returns: Array of zeros with the same shape and type as `arr`.
    public static func zeros(like arr: ndArray<T>) -> ndArray<Self.Element> {
        let value: Self.Element = 0
        
        return self.init(shape: arr.shape, repeating: value)
    }
    
    /// Return an array of ones with the same shape and type of input.
    /// - Parameter arr: The shape and data-type of `arr` define these same attributes of the returned array.
    /// - Returns: Array of ones with the same shape and type as `arr`.
    public static func ones(like arr: ndArray) -> ndArray<Self.Element> {
        let value: Self.Element = 1
        
        return self.init(shape: arr.shape, repeating: value)
    }
}
