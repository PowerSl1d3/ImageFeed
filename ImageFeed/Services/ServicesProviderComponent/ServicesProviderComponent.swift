//
//  ServicesProviderComponent.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 10.01.2024.
//

import NeedleFoundation

final class ServicesProviderComponent: Component<EmptyDependency> {
    var oauth2Service: OAuth2Service {
        OAuth2Service()
    }

    var profileService: ProfileServiceProtocol {
        shared {
            ProfileService()
        }
    }

    var profileImageService: ProfileImageServiceProtocol {
        shared {
            ProfileImageService()
        }
    }

    var imageListService: ImagesListServiceProtocol {
        ImagesListService()
    }

    var alertPresenterService: AlertPresenterServiceProtocol {
        AlertPresenterService()
    }
}
