

import NeedleFoundation
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class ImagesListDependencyd8b607949c67339775c3Provider: ImagesListDependency {
    var servicesProviderComponent: ServicesProviderComponent {
        return rootComponent.servicesProviderComponent
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->ImagesListComponent
private func factory6d46875360e3521ca8ceb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ImagesListDependencyd8b607949c67339775c3Provider(rootComponent: parent1(component) as! RootComponent)
}
private class SplashDependency765f43167a3bd58031caProvider: SplashDependency {
    var servicesProviderComponent: ServicesProviderComponent {
        return rootComponent.servicesProviderComponent
    }
    var tabBarComponent: TabBarComponent {
        return rootComponent.tabBarComponent
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->SplashComponent
private func factorya8b137056976721a475ab3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SplashDependency765f43167a3bd58031caProvider(rootComponent: parent1(component) as! RootComponent)
}
private class TabBarDependency8fc83c57bebb8079d10cProvider: TabBarDependency {
    var imagesListComponent: ImagesListComponent {
        return rootComponent.imagesListComponent
    }
    var profileComponent: ProfileComponent {
        return rootComponent.profileComponent
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->TabBarComponent
private func factory624b559fba4c3bb2d05bb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return TabBarDependency8fc83c57bebb8079d10cProvider(rootComponent: parent1(component) as! RootComponent)
}
private class ProfileDependency6818e92e498fe07e2622Provider: ProfileDependency {
    var servicesProviderComponent: ServicesProviderComponent {
        return rootComponent.servicesProviderComponent
    }
    var splashComponent: SplashComponent {
        return rootComponent.splashComponent
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->ProfileComponent
private func factory62ee3a75b16d091e8f01b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ProfileDependency6818e92e498fe07e2622Provider(rootComponent: parent1(component) as! RootComponent)
}

#else
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
extension RootComponent: Registration {
    public func registerItems() {

        localTable["servicesProviderComponent-ServicesProviderComponent"] = { [unowned self] in self.servicesProviderComponent as Any }
        localTable["splashComponent-SplashComponent"] = { [unowned self] in self.splashComponent as Any }
        localTable["tabBarComponent-TabBarComponent"] = { [unowned self] in self.tabBarComponent as Any }
        localTable["imagesListComponent-ImagesListComponent"] = { [unowned self] in self.imagesListComponent as Any }
        localTable["profileComponent-ProfileComponent"] = { [unowned self] in self.profileComponent as Any }
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
    registerProviderFactory("^->RootComponent->ServicesProviderComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->ImagesListComponent", factory6d46875360e3521ca8ceb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->SplashComponent", factorya8b137056976721a475ab3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->TabBarComponent", factory624b559fba4c3bb2d05bb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->ProfileComponent", factory62ee3a75b16d091e8f01b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
