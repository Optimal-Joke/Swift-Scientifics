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

// MARK: - Public Array Properties
extension ndArray {
    public var count: Int { buffer.count }
}

extension ndArray {
    // MARK: Static Methods
    
    /// <#Description#>
    /// - Parameter buffer: The data buffer whose shape is to be determined.
    /// - Parameter partialShape:
    private static func inferShape(buffer: UnsafeMutableBufferPointer<T>, partialShape: [Int]) -> [Int] {
        var newShape = partialShape
        
        let partialCount = partialShape.product
        let remainingCount = buffer.count - partialCount
        
        newShape.append(remainingCount)
        
        return newShape
    }
    
    static func reshape(_ arr: ndArray, _ newShape: [Int]) throws -> [Int] {
        //        guard arr.nElems == newShape.product else { throw Error }
        
        return []
    }
}
