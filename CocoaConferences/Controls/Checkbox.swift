//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI

public struct Checkbox: View {
    var text = "%text%"
    @Binding var checked: Bool

    public var body: some View {
        HStack {
            Toggle(isOn: self.$checked) {
                Text(text)
            }
        }
    }
}

class CheckboxPreview: PreviewProvider {
    static var previews: some View {
        Group {
            Checkbox(checked: .constant(false)).previewLayout(.sizeThatFits)
            Checkbox(checked: .constant(true)).previewLayout(.sizeThatFits)
        }
    }
    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
        UIHostingController(rootView: CheckboxPreview.previews)
    }
    #endif
}
