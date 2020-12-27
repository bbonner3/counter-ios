//
//  Settings.swift
//  counter
//
//  Created by Coding on 12/26/20.
//

import Foundation
import SwiftUI

enum Theme:String {
    case systemDefault
    case light
    case dark
    case oled
}

class ThemeController {
    private(set) lazy var currentTheme = loadTheme()
    private let defaults:UserDefaults
    private let defaultsKey = "theme"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func changeTheme(to theme: Theme) {
        currentTheme = theme
        defaults.setValue(theme.rawValue, forKey: defaultsKey)
    }

    private func loadTheme() -> Theme {
        let rawValue = defaults.string(forKey: defaultsKey)
        return rawValue.flatMap(Theme.init) ?? .systemDefault
    }
}

enum Layout:String {
    case minus
    case plusminus
    case plus
}

class LayoutController:ObservableObject {
    @AppStorage(wrappedValue: Layout.plusminus, "buttonLayout") var currentBtnLayout:Layout
    @AppStorage(wrappedValue: false, "isInvert") var isInvert:Bool
}

class LimitController:ObservableObject {
    @AppStorage(wrappedValue: 9999, "limitValue") var currentLimitValue:Int
    @AppStorage(wrappedValue: 0, "resetValue") var currentResetValue:Int
}
