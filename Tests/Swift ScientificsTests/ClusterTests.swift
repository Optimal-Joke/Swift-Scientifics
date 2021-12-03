//
//  ClusterTests.swift
//  
//
//  Created by Hunter Holland on 12/3/21.
//

import XCTest
@testable import Swift_Scientifics

final class ClusterTests: XCTestCase {
    
    // MARK: BDSCAN
    func testObjectInitialization() throws {
        let dbscan = DBSCAN<Double>(epsilon: 0.75, minSamples: 10)
        
        XCTAssertEqual(dbscan.epsilon, 0.75)
        XCTAssertEqual(dbscan.minSamples, 10)
    }
}

