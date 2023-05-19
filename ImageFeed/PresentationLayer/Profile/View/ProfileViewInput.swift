//
//  ProfileViewInput.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

import UIKit

protocol ProfileViewInput: UIViewController {
    func updateProfileDetails(profile: Profile)
    func updateAvatar(with url: URL)
}
