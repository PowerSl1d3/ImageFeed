//
//  WebView+Unsplash.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 14.05.2023.
//

import Foundation
import WebKit

extension WKWebView {
    static func clean() {
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
}
