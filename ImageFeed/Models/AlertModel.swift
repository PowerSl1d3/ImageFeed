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
    let buttonText: String
    var completion: (() -> Void)? = nil
}
