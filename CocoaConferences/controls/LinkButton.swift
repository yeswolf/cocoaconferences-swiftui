//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI

public class LinkButtonViewModel: ObservableObject {
    var title: String
    var link: String

    public init(title: String, link: String) {
        self.title = title
        self.link = link
    }

    func click() -> Void {
        let url = URL(string: link)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

public struct LinkButton: View {
    var viewModel: LinkButtonViewModel
    public var body: some View {
        Button(action: viewModel.click) {
            Text(viewModel.title).underline().lineLimit(1)
        }
    }
}

class LinkButtonPreview: PreviewProvider {
    static var previews: some View {
        Group {
            LinkButton(viewModel: LinkButtonViewModel(title: "%title%", link: "https://www.google.com")).previewLayout(.sizeThatFits)
        }
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: LinkButtonPreview.previews)
    }
    #endif
}
