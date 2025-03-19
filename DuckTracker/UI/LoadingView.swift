import SwiftUI

enum LoadingSize {
    case small, medium

    var font: Font {
        switch self {
        case .small:
            Font.caption.bold()
        case .medium:
            Font.title2.bold()
        }
    }
}

struct LoadingView: View {
    let loadingSize: LoadingSize

    init(withSize loadingSize: LoadingSize) {
        self.loadingSize = loadingSize
    }

    init() {
        self.init(withSize: .medium)
    }

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 10) {
                ProgressView()
                HStack {
                    Spacer()
                    Text(".loading".localized()).font(loadingSize.font)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

#Preview("Small") {
    LoadingView(withSize: .small)
}

#Preview("Medium") {
    LoadingView(withSize: .medium)
}
