import SwiftUI

fileprivate struct ActiveTrackInfoGPSLiquidGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular, in: .capsule)
        } else if #available(iOS 16.0, *) {
            content
                .background(Color.commonElementBackground.opacity(0.7))
                .clipShape(.capsule)
        } else {
            content
                .background(Color.commonElementBackground.opacity(0.7))
        }
    }
}

struct ActiveTrackInfoGPSView: View {

    let isRecording: Bool

    @ObservedObject private var locationProvider = LocationProvider.shared

    var body: some View {
        let acc: Int = locationProvider.userLocation != nil ? Int(locationProvider.userLocation!.horizontalAccuracy) : 0
        let color: Color = acc <= 10 && acc > 0 ? .gpsGood : (acc <= 30 && acc > 0 ? .gpsMedium : .gpsBad)
        let isFull: Bool = acc > 10 || acc <= 0 || !isRecording

        HStack(spacing: 5) {
            Image(systemName: "dot.radiowaves.left.and.right")
            if isFull {
                Text(".gps".localized()).fontWeight(.semibold)
            }
        }
        .foregroundColor(color)
        .padding(10)
        .modifier(ActiveTrackInfoGPSLiquidGlassModifier())
    }
}

struct TrackGPS_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            Spacer()
            HStack {
                Spacer()
                ActiveTrackInfoGPSView(isRecording: true)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                ActiveTrackInfoGPSView(isRecording: false)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .background(Color.yellow)
    }
}
