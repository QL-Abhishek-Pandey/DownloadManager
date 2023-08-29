//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation


enum TaskResult {
    case download(URL)
    case progress(Float)
    case failure(Error)
}
