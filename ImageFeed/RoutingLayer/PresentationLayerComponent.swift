//
//  PresentationLayerComponent.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 07.12.2023.
//

import Swinject
import NeedleFoundation

protocol PresentationLayerDependency: Dependency {
    var servicesProviderComponent: ServicesProviderComponent { get }
}

final class PresentationLayerComponent: Component<PresentationLayerDependency> {
    static let assembler = Assembler([
        SplashViewControllerAssembly(),
        TabBarComponent(),
        ImagesListAssembly(),
        ProfileAssembly()
    ])

    private convenience init() {
        self.init(parent: BootstrapComponent())
    }

    public var servicesProviderComponent: ServicesProviderComponent {
        dependency.servicesProviderComponent
    }

    public var splashComponent: SplashComponent {
        SplashComponent(parent: self)
    }
}

extension PresentationLayerComponent: SplashDependency {
    public var tabBarComponent: TabBarComponent {
        TabBarComponent(parent: self)
    }
}

extension PresentationLayerComponent: TabBarDependency {
    public var imagesListComponent: ImagesListComponent {
        ImagesListComponent(parent: self)
    }

    public var profileComponent: ProfileComponent {
        ProfileComponent(parent: self)
    }
}

