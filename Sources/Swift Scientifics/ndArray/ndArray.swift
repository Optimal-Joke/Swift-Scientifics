//
//  ndArray.swift
//
//
//  Created by Hunter Holland on 12/1/21.
//

import Foundation

public struct ndArray<T: Numeric>: MutableCollection {
    private var buffer: UnsafeMutableBufferPointer<T>
    
    /// The dimensions of the array.
    ///
    /// The `shape` property is usually used to get the current dimensions of the array. To change it for an array `arr`, call `arr.reshape`.
    public private(set) var shape: [Int] {
        willSet {
            self.strides = Self.calcStrides(forShape: newValue, itemSize: self.itemSize)
        }
    }
    
    /// Array of bytes to step in each dimension when traversing an array.
    public private(set) var strides: [Int]
    
    /// The number of dimensions in the array.
    public var nDim: Int { self.shape.count }
    
    /// The number of elements in the array.
    public var size: Int { self.shape.reduce(1, *) }
    
    /// The size, in bytes, of each element in the array.
    public let itemSize: Int = MemoryLayout<T>.size
    
    // MARK: Initializers
    init(shape: [Int]) {
        self.buffer = UnsafeMutableBufferPointer<T>.allocate(capacity: shape.product)
        self.shape = shape
        self.strides = Self.calcStrides(forShape: shape, itemSize: MemoryLayout<T>.size)
    }
    
    init(shape: [Int], repeating val: T) {
        self.buffer = UnsafeMutableBufferPointer<T>.calloc(count: shape.product, value: val)
        self.shape = shape
        self.strides = Self.calcStrides(forShape: shape, itemSize: MemoryLayout<T>.size)
    }
    
    init(buffer: UnsafeMutableBufferPointer<T>) { // TODO: Add ability to pass shape parameter
        self.buffer = buffer
        self.shape = [buffer.count]
        self.strides = Self.calcStrides(forShape: shape, itemSize: MemoryLayout<T>.size)
    }
    
    init(_ array: [T]) {
        self.buffer = UnsafeMutableBufferPointer<T>.malloc(count: array.count)
        _ = self.buffer.initialize(from: array)
        
        self.shape = [buffer.count]
        self.strides = Self.calcStrides(forShape: shape, itemSize: MemoryLayout<T>.size)
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

extension ndArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

// MARK: - Buffer/View Manipulation
extension ndArray {
    
    /// Calculates the appropriate strides for an array of the given shape and with elements of the given size.
    ///
    /// This method should only be called when ``ndarray.reshape`` is called. It assumes that `shape`
    /// is a valid shape
    /// - Parameters:
    ///   - shape: The shape of the array whose strides are being calculated.
    ///   - itemsize: The size (in bytes) of each element in the array.
    /// - Returns: An array of dimension-wise strides.
    private static func calcStrides(forShape shape: [Int], itemSize: Int) -> [Int] {
        var strides = Array(repeating: 0, count: shape.count)
        
        for i in shape.indices {
            guard i > 0 else {
                strides[i] = shape.product / shape[i] * itemSize
                continue
            }
            
            strides[i] = shape.product / shape[i] / shape[..<i].product * itemSize
        }
        
        return strides
    }
    
    public mutating func reshape(_ newShape: [Int]) throws {
        var shape = newShape
        
        if let idx = newShape.firstIndex(of: -1) { // handle presence of -1
            let numUnknownDimensions = newShape.filter({ $0 == -1 }).count

            guard numUnknownDimensions == 1 else {
                throw ArrayShapeError.TooManyUnknownDimensions(count: numUnknownDimensions)
            }
            
            let otherDimProduct = newShape.product * -1
            
            guard self.size.isMultiple(of: otherDimProduct) else {
                throw ArrayShapeError.InvalidShapeForSize(shape: newShape, size: self.size)
            }
            
            let newDim = self.size / otherDimProduct
            shape[idx] = newDim
        }
                
        guard self.size == shape.product else {
            throw ArrayShapeError.InvalidShapeForSize(shape: shape, size: self.size)
        }
        
        self.shape = shape
    }
    
    /// <#Description#>
    /// - Parameter axes: <#axes description#>
    public mutating func transpose(_ axes: [Int]?) throws {
//        guard let axes = axes else { }
    }
    
    public mutating func swapAxes(axis1: Int, axis2: Int) throws {
        var newShape = self.shape
        newShape.swapAt(axis1, axis2)
        self.shape = newShape
        self.strides = Self.calcStrides(forShape: newShape, itemSize: self.itemSize)
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

// MARK: - Arithmetic
extension ndArray {
    // FIXME: Arithmetic operations should only be implemented when array can be reshaped etc.
}
