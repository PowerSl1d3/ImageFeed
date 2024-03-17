

import NeedleFoundation
import Swinject
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class PresentationLayerDependency22e38cab0765e0091717Provider: PresentationLayerDependency {
    var servicesProviderComponent: ServicesProviderComponent {
        return rootComponent.servicesProviderComponent
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->PresentationLayerComponent
private func factoryced55e730fd4f6e9b29eb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PresentationLayerDependency22e38cab0765e0091717Provider(rootComponent: parent1(component) as! RootComponent)
}
private class ImagesListDependencydc2d42348672f26a80ceProvider: ImagesListDependency {
    var servicesProviderComponent: ServicesProviderComponent {
        return presentationLayerComponent.servicesProviderComponent
    }
    private let presentationLayerComponent: PresentationLayerComponent
    init(presentationLayerComponent: PresentationLayerComponent) {
        self.presentationLayerComponent = presentationLayerComponent
    }
}
/// ^->RootComponent->PresentationLayerComponent->ImagesListComponent
private func factory3b3a0dbcdff4539c0b442b769d7a06d1263c934a(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ImagesListDependencydc2d42348672f26a80ceProvider(presentationLayerComponent: parent1(component) as! PresentationLayerComponent)
}
private class SplashDependency7192d4c930f56b878f44Provider: SplashDependency {
    var servicesProviderComponent: ServicesProviderComponent {
        return presentationLayerComponent.servicesProviderComponent
    }
    var tabBarComponent: TabBarComponent {
        return presentationLayerComponent.tabBarComponent
    }
    private let presentationLayerComponent: PresentationLayerComponent
    init(presentationLayerComponent: PresentationLayerComponent) {
        self.presentationLayerComponent = presentationLayerComponent
    }
}
/// ^->RootComponent->PresentationLayerComponent->SplashComponent
private func factory63438918786602c2fe182b769d7a06d1263c934a(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SplashDependency7192d4c930f56b878f44Provider(presentationLayerComponent: parent1(component) as! PresentationLayerComponent)
}
private class TabBarDependency68f72f36094d0b81850dProvider: TabBarDependency {
    var imagesListComponent: ImagesListComponent {
        return presentationLayerComponent.imagesListComponent
    }
    var profileComponent: ProfileComponent {
        return presentationLayerComponent.profileComponent
    }
    private let presentationLayerComponent: PresentationLayerComponent
    init(presentationLayerComponent: PresentationLayerComponent) {
        self.presentationLayerComponent = presentationLayerComponent
    }
}
/// ^->RootComponent->PresentationLayerComponent->TabBarComponent
private func factory6639a8889458ce07adeb2b769d7a06d1263c934a(_ component: NeedleFoundation.Scope) -> AnyObject {
    return TabBarDependency68f72f36094d0b81850dProvider(presentationLayerComponent: parent1(component) as! PresentationLayerComponent)
}
private class ProfileDependency574519d188a7e0e5bf83Provider: ProfileDependency {
    var servicesProviderComponent: ServicesProviderComponent {
        return presentationLayerComponent.servicesProviderComponent
    }
    var splashComponent: SplashComponent {
        return presentationLayerComponent.splashComponent
    }
    private let presentationLayerComponent: PresentationLayerComponent
    init(presentationLayerComponent: PresentationLayerComponent) {
        self.presentationLayerComponent = presentationLayerComponent
    }
}
/// ^->RootComponent->PresentationLayerComponent->ProfileComponent
private func factory6110ab81e12f105f374e2b769d7a06d1263c934a(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ProfileDependency574519d188a7e0e5bf83Provider(presentationLayerComponent: parent1(component) as! PresentationLayerComponent)
}

#else
extension RootComponent: Registration {
    public func registerItems() {

        localTable["presentationLayerComponent-PresentationLayerComponent"] = { [unowned self] in self.presentationLayerComponent as Any }
        localTable["servicesProviderComponent-ServicesProviderComponent"] = { [unowned self] in self.servicesProviderComponent as Any }
    }
}
extension PresentationLayerComponent: Registration {
    public func registerItems() {
        keyPathToName[\PresentationLayerDependency.servicesProviderComponent] = "servicesProviderComponent-ServicesProviderComponent"
        localTable["servicesProviderComponent-ServicesProviderComponent"] = { [unowned self] in self.servicesProviderComponent as Any }
        localTable["splashComponent-SplashComponent"] = { [unowned self] in self.splashComponent as Any }
        localTable["tabBarComponent-TabBarComponent"] = { [unowned self] in self.tabBarComponent as Any }
        localTable["imagesListComponent-ImagesListComponent"] = { [unowned self] in self.imagesListComponent as Any }
        localTable["profileComponent-ProfileComponent"] = { [unowned self] in self.profileComponent as Any }
    }
}
extension ServicesProviderComponent: Registration {
    public func registerItems() {

    }
}
extension ImagesListComponent: Registration {
    public func registerItems() {
        keyPathToName[\ImagesListDependency.servicesProviderComponent] = "servicesProviderComponent-ServicesProviderComponent"
    }
}
extension SplashComponent: Registration {
    public func registerItems() {
        keyPathToName[\SplashDependency.servicesProviderComponent] = "servicesProviderComponent-ServicesProviderComponent"
        keyPathToName[\SplashDependency.tabBarComponent] = "tabBarComponent-TabBarComponent"
    }
}
extension TabBarComponent: Registration {
    public func registerItems() {
        keyPathToName[\TabBarDependency.imagesListComponent] = "imagesListComponent-ImagesListComponent"
        keyPathToName[\TabBarDependency.profileComponent] = "profileComponent-ProfileComponent"
    }
}
extension ProfileComponent: Registration {
    public func registerItems() {
        keyPathToName[\ProfileDependency.servicesProviderComponent] = "servicesProviderComponent-ServicesProviderComponent"
        keyPathToName[\ProfileDependency.splashComponent] = "splashComponent-SplashComponent"
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->PresentationLayerComponent", factoryced55e730fd4f6e9b29eb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->ServicesProviderComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->PresentationLayerComponent->ImagesListComponent", factory3b3a0dbcdff4539c0b442b769d7a06d1263c934a)
    registerProviderFactory("^->RootComponent->PresentationLayerComponent->SplashComponent", factory63438918786602c2fe182b769d7a06d1263c934a)
    registerProviderFactory("^->RootComponent->PresentationLayerComponent->TabBarComponent", factory6639a8889458ce07adeb2b769d7a06d1263c934a)
    registerProviderFactory("^->RootComponent->PresentationLayerComponent->TabBarComponent", factory6639a8889458ce07adeb2b769d7a06d1263c934a)
    registerProviderFactory("^->RootComponent->PresentationLayerComponent->ProfileComponent", factory6110ab81e12f105f374e2b769d7a06d1263c934a)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
