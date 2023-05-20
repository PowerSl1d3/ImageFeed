//
//  ProfileRouterInput.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

protocol ProfileRouterInput {
    func switchToSplashController()
    func showProfileExitAlert(
        successfullCompletion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    )
}
