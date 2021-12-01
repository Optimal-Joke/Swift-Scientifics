//
//  ndArrayTests.swift
//  
//
//  Created by Hunter Holland on 12/1/21.
//

import XCTest
@testable import Swift_Scientifics

final class ndArrayTests: XCTestCase {
    
    // MARK: Array Creation
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
}

