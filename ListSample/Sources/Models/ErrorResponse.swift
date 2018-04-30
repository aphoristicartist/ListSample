//
//  ErrorPage.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/27/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let status: String
    let code: String
    let message: String
}
