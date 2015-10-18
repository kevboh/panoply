//
//  Result.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import Foundation

/// A simple box around a value or an error.
struct Result<T> {
    /// The value of this Result. Present if there is no error.
    let value : T?
    /// The error if this Result. Present if there is no value.
    let error : ErrorType?
    
    /// Create a Result with a value.
    init(_ value: T) {
        self.value = value
        self.error = nil
    }
    
    /// Create a Result with an error.
    init(_ error: ErrorType) {
        self.value = nil
        self.error = error
    }
}