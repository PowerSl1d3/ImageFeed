//
//  PresentationLayerAssembler.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 07.12.2023.
//

import Swinject

final class PresentationLayerAssembler {
    static let assembler = Assembler([
        SplashViewControllerAssembly(),
        TabBarAssembly(),
        ImagesListAssembly(),
        ProfileAssembly()
    ])

    private init() {}
}
