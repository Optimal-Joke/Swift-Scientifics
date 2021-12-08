//
//  File.swift
//  
//
//  Created by Hunter Holland on 12/3/21.
//

import Foundation

// MARK: ndArray
extension ndArray {
    enum ArrayShapeError: Error, Equatable, CustomStringConvertible {
        // Throw when an invalid shape is used for the size of the array.
        case InvalidShapeForSize(shape: [Int], size: Int)
        
        // Throw when more than one dimension in a shape is -1.
        case TooManyUnknownDimensions(count: Int)
        
        // Throw when an attempt is made to access an axis that doesn't exist.
        case InvalidAxis(axis: Int, nDims: Int)
        
        // Throw in all other cases
        case unexpected(code: Int)
        
        public var description: String {
            switch self {
            case .InvalidShapeForSize(let shape, let size):
                return "Cannot reshape array of size \(size) into shape \(shape)."
            case .TooManyUnknownDimensions(let count):
                return "May only specify 1 unknown dimension. You specified \(count)."
            case .InvalidAxis(let axis, let nDims):
                return "Axis \(axis) does not exist in array of dimension \(nDims)."
            case .unexpected(_):
                return "An unexpected error occurred."
            }
        }
    }
}

// MARK: DBSCAN
extension DBSCAN {
    enum DBSCANError: Error, Equatable, CustomStringConvertible  {
        // Throw when `minSamples` is non-positive.
//        case InvalidMinSamples(count: Int)
        
        var description: String {
            switch self {
           
            }
        }
    }
}


