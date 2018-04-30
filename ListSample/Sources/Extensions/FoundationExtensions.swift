//
//  FoundationExtensions.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/27/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import Foundation
import RxSwift

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

public extension ObserverType {
    
    public func onNextAndCompleted(_ element: Self.E) {
        onNext(element)
        onCompleted()
    }
}
