//
//  UIFont+ImageFeedFonts.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 04.12.2023.
//

import UIKit

extension UIFont {
    static func ypRegularFont(ofSize size: CGFloat) -> UIFont {
        UIFont(name: "YandexSansDisplay-Regular", size: size)!
    }

    static func ypMediumFont(ofSize size: CGFloat) -> UIFont {
        UIFont(name: "YandexSansText-Medium", size: size)!
    }

    static func ypBoldFont(ofSize size: CGFloat) -> UIFont {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })

        return UIFont(name: "YandexSansDisplay-Bold", size: size)!
    }
}
