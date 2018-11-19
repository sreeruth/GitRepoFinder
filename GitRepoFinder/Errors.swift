//
//  Errors.swift
//  GitRepoFinder
//
//  Created by EXI-Ruthala, Sreekanth on 11/18/18.
//  Copyright © 2018 SelfOrg. All rights reserved.
//

import Foundation

enum DataError: Error {
    case NoData
    case NoSearch
    case UnSerializableJSON
}
