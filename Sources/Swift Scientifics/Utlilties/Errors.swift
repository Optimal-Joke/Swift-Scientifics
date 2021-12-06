//
//  File.swift
//  
//
//  Created by Hunter Holland on 12/3/21.
//

import Foundation

extension ndArray {
    enum ArrayShapeError: Error, Equatable, CustomStringConvertible {
        // Throw when an invalid shape is used for the size of the array.
        case InvalidShapeForSize(shape: [Int], size: Int)
        
        // Throw when more than one dimension in a shape is -1.
        case TooManyUnknownDimensions(count: Int)
        
        // Throw in all other cases
        case unexpected(code: Int)
        
        public var description: String {
            switch self {
            case .InvalidShapeForSize(let shape, let size):
                return "Cannot reshape array of size \(size) into shape \(shape)."
            case .TooManyUnknownDimensions(let count):
                return "May only specify 1 unknown dimension. You specified \(count)."
            case .unexpected(_):
                return "An unexpected error occurred."
            }
        }
    }
}

