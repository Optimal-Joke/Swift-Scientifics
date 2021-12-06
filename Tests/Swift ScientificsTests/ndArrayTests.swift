//
//  ndArrayTests.swift
//  
//
//  Created by Hunter Holland on 12/1/21.
//

import XCTest
@testable import Swift_Scientifics

final class ndArrayTests: XCTestCase {
    
    // MARK: Creation
    func testCreateUninitializedArray() throws {
        let array1 = ndArray<Int>(shape: [3, 4, 5])
        let array2 = ndArray<Int>(shape: [3, 4, 5])
        
        XCTAssertNotEqual(array1, array2)
    }
    
    func testCreateInitializedArray() throws {
        let swiftArray = [1, 2, 3, 4, 5]
        let array = ndArray(swiftArray)
        
        XCTAssertTrue(array.elementsEqual(swiftArray))
        XCTAssertTrue(array.count == swiftArray.count)
    }
    
    func testCreateWithRepeatingValue() throws {
        let array = ndArray(shape: [5], repeating: 1)
        
        XCTAssertTrue(array.allSatisfy { $0 == 1 })
    }
    
    func testCreateFromArrayLiteral() throws {
        let literal: [Double] = [1, 2, 3, 4, 5]
        let array: ndArray<Double> = [1, 2, 3, 4, 5]
        
        XCTAssertTrue(array.elementsEqual(literal))
        XCTAssertTrue(array.count == literal.count)
    }
    
    func testZeros() throws {
        let array = ndArray<Int>.zeros(shape: [5])
        
        XCTAssertTrue(array.allSatisfy { $0 == 0 })
    }
    
    func testOnes() throws {
        let array = ndArray<Int>.ones(shape: [5])
        
        XCTAssertTrue(array.allSatisfy { $0 == 1 })
    }

    func testZerosLike() throws {
        let array1 = ndArray<Double>(shape: [3, 4, 5], repeating: 0)
        let array2 = ndArray.zeros(like: array1)
        
        XCTAssertEqual(array1.shape, array2.shape)
    }
    
    func testOnesLike() throws {
        let array1 = ndArray<Double>(shape: [3, 4, 5], repeating: 1)
        let array2 = ndArray.ones(like: array1)

        XCTAssertEqual(array1.shape, array2.shape)
    }
    
    // MARK: Metadata Configuration
    func testConfigFromInit() throws {
        let array = ndArray<Int32>(shape: [2, 3, 4], repeating: 0)
        
        XCTAssertEqual(array.shape, [2, 3, 4])
        XCTAssertEqual(array.strides, [48, 16, 4])
        XCTAssertEqual(array.nDim, 3)
        XCTAssertEqual(array.size, 24)
        XCTAssertEqual(array.itemSize, 4)
    }
    
    // MARK: Reshape
    func testSuccessfulReshape1() throws {
        var array = ndArray(shape: [2, 3, 4], repeating: 0)
        
        try array.reshape([-1])
        XCTAssertEqual(array.shape, [24])
    }
    
    func testSuccessfulReshape2() throws {
        var array = ndArray(shape: [2, 3, 4], repeating: 0)
        
        try array.reshape([-1, 2])
        XCTAssertEqual(array.shape, [12, 2])
    }
    
    func testSuccessfulReshape3() throws {
        var array = ndArray(shape: [2, 3, 4], repeating: 0)
        
        try array.reshape([-1, 2, 4])
        XCTAssertEqual(array.shape, [3, 2, 4])
    }
    
    func testSuccessfulReshape4() throws {
        var array = ndArray(shape: [2, 3, 4], repeating: 0)
        
        try array.reshape([2, 3, 2, -1])
        XCTAssertEqual(array.shape, [2, 3, 2, 2])
    }
    
    func testFailedReshape1() throws {
        typealias Element = Int
        
        var array = ndArray<Element>(shape: [2, 3, 4], repeating: 0)
        let newShape = [-2]
        
        var thrownError: Error?
        
        XCTAssertThrowsError(try array.reshape(newShape)) {
            thrownError = $0
        }
        
        XCTAssertTrue(
            thrownError is ndArray<Element>.ArrayShapeError
        )
        
        XCTAssertEqual(thrownError as? ndArray<Element>.ArrayShapeError, .InvalidShapeForSize(shape: newShape, size: array.size))
    }
    
    func testFailedReshape2() throws {
        typealias Element = Int
        
        var array = ndArray<Element>(shape: [2, 3, 4], repeating: 0)
        let newShape = [-1, 5]
        
        var thrownError: Error?
        
        XCTAssertThrowsError(try array.reshape(newShape)) {
            thrownError = $0
        }
        
        XCTAssertTrue(
            thrownError is ndArray<Element>.ArrayShapeError
        )
        
        XCTAssertEqual(thrownError as? ndArray<Element>.ArrayShapeError, .InvalidShapeForSize(shape: newShape, size: array.size))
    }
    
    func testFailedReshape3() throws {
        typealias Element = Int
        
        var array = ndArray<Element>(shape: [2, 3, 4], repeating: 0)
        let newShape = [-1, 2, 5]
        
        var thrownError: Error?
        
        XCTAssertThrowsError(try array.reshape(newShape)) {
            thrownError = $0
        }
        
        XCTAssertTrue(
            thrownError is ndArray<Element>.ArrayShapeError
        )
        
        XCTAssertEqual(thrownError as? ndArray<Element>.ArrayShapeError, .InvalidShapeForSize(shape: newShape, size: array.size))
    }
    
    func testFailedReshape4() throws {
        typealias Element = Int
        
        var array = ndArray<Element>(shape: [2, 3, 4], repeating: 0)
        let newShape = [2, 3, 2, 3]
        
        var thrownError: Error?
        
        XCTAssertThrowsError(try array.reshape(newShape)) {
            thrownError = $0
        }
        
        XCTAssertTrue(
            thrownError is ndArray<Element>.ArrayShapeError
        )
        
        XCTAssertEqual(thrownError as? ndArray<Element>.ArrayShapeError, .InvalidShapeForSize(shape: newShape, size: array.size))
    }
    
    func testFailedReshape5() throws {
        typealias Element = Int
        
        var array = ndArray<Element>(shape: [2, 3, 4], repeating: 0)
        let newShape = [2, 3, -1, -1]
        
        var thrownError: Error?
        
        // Capture the thrown error using a closure
        XCTAssertThrowsError(try array.reshape(newShape)) {
            thrownError = $0
        }
        
        // First we’ll verify that the error is of the right
        // type, to make debugging easier in case of failures.
        XCTAssertTrue(
            thrownError is ndArray<Element>.ArrayShapeError
        )
        
        // Verify that our error is equal to what we expect
        XCTAssertEqual(thrownError as? ndArray<Element>.ArrayShapeError, .TooManyUnknownDimensions(count: 2))
    }
    
    // MARK: Data Manipulation
    func testSubscriptEdit() throws {
        var array = ndArray(shape: [2, 3, 4], repeating: 0)
        
        array[0] = 1
        
        XCTAssertEqual(array[0], 1)
    }
}

