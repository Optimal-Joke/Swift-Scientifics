//
//  DBSCAN.swift
//  
//
//  Created by Hunter Holland on 12/3/21.
//

import Foundation

// MARK: - DBSCAN Execution Object
public struct DBSCAN<T: Numeric> {
    /// The maximum distance between two samples for one to be considered as in the neighborhood of the other.
    ///
    /// This is not a maximum bound on the distances of points within a cluster. *This is the most important DBSCAN parameter to
    /// choose appropriately for your data set and distance function.*
    public var epsilon: Double
    
    /// The number of samples in a neighborhood for a point to be considered as a core point, including the point itself.
    public var minSamples: Int
    
    public init(epsilon: Double = 0.5, minSamples: Int = 5) {
        precondition(minSamples > 0, "Value of `minSamples` must be greater than 0.")
        
        self.epsilon = epsilon
        self.minSamples = minSamples
    }
}

extension DBSCAN {
    public func fit(_ data: ndArray<T>) -> DBSCANResult<T> {
        undefined("Not yet implemented")
    }
}

// MARK: DBSCAN Result Object
public struct DBSCANResult<T: Numeric> {
    let clusters: ndArray<T>
    let outliers: ndArray<T>
}
