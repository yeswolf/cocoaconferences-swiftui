//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI

public struct LinkButton: View {
    var title = ""
    var link = ""
    public var body: some View {
        Button(action: {
            let url = URL(string: self.link)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }) {
            Text(self.title).underline().lineLimit(1)
        }
    }
}

class LinkButtonPreview: PreviewProvider {
    static var previews: some View {
        Group {
            LinkButton(title: "%title%", link: "https://www.google.com").previewLayout(.sizeThatFits)
        }
    }
    #if DEBUG
        @objc class func  injected() {
            UIApplication.shared.windows.first?.rootViewController =
            UIHostingController(rootView: LinkButtonPreview.previews)
        }
    #endif
}
