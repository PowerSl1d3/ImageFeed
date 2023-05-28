//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 02.05.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    var successfulButtonText: String? = nil
    var cancelButtonText: String? = nil
    var successfulCompletion: (() -> Void)? = nil
    var cancelCompletion: (() -> Void)? = nil
}
