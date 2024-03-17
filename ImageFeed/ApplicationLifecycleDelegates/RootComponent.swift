//
//  RootComponent.swift
//  ImageFeed
//
//  Created by Oleg Aksenenko on 11.01.2024.
//

import NeedleFoundation

final class RootComponent: BootstrapComponent {
    public var servicesProviderComponent: ServicesProviderComponent {
        shared {
            ServicesProviderComponent(parent: self)
        }
    }

    public var splashComponent: SplashComponent {
        SplashComponent(parent: self)
    }
}

extension RootComponent: SplashDependency {
    public var tabBarComponent: TabBarComponent {
        TabBarComponent(parent: self)
    }
}

extension RootComponent: TabBarDependency {
    public var imagesListComponent: ImagesListComponent {
        ImagesListComponent(parent: self)
    }

    public var profileComponent: ProfileComponent {
        ProfileComponent(parent: self)
    }
}
