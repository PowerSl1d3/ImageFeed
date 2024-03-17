//
//  RootComponent.swift
//  ImageFeed
//
//  Created by Oleg Aksenenko on 11.01.2024.
//

import NeedleFoundation

final class RootComponent: BootstrapComponent {
    public var presentationLayerComponent: PresentationLayerComponent {
        shared {
            PresentationLayerComponent(parent: self)
        }
    }
}

extension RootComponent: PresentationLayerDependency {
    public var servicesProviderComponent: ServicesProviderComponent {
        shared {
            ServicesProviderComponent(parent: self)
        }
    }
}
