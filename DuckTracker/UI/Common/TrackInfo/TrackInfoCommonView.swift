import SwiftUI
import MapKit

struct TrackInfoCommonView: View {

    let distance: CLLocationDistance?
    let avgSpeed: CLLocationSpeed?
    let maxSpeed: CLLocationSpeed?
    let timeString: String?
    let withSpacers: Bool

    var body: some View {
        HStack(spacing: 1) {
            VStack(spacing: 1) {
                TrackInfoElementView(
                    title: ".avgspeed".localized().uppercased(),
                    text: avgSpeed?.prepareStringKmh(),
                    rightSpacer: withSpacers,
                    position: .topLeadingCutted
                )
                TrackInfoElementView(
                    title: ".maxspeed".localized().uppercased(),
                    text: maxSpeed?.prepareStringKmh(),
                    rightSpacer: withSpacers,
                    position: .bottomLeadingCutted
                )
            }

            VStack(spacing: 1) {
                TrackInfoElementView(
                    title: ".time".localized().uppercased(),
                    text: timeString,
                    leftSpacer: withSpacers,
                    position: .topTrailingCutted
                )
                TrackInfoElementView(
                    title: ".distance".localized().uppercased(),
                    text: distance?.prepareString(),
                    leftSpacer: withSpacers,
                    position: .bottomTrailingCutted
                )
            }
        }
    }
}

struct TrackInfoCommonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            TrackInfoCommonView(distance: 123.4, avgSpeed: 12.34, maxSpeed: 123.4, timeString: "01:00:59", withSpacers: true)

            TrackInfoCommonView(distance: 12.42, avgSpeed: 12.34, maxSpeed: 123.4, timeString: "12:01:59", withSpacers: false)

            TrackInfoCommonView(distance: nil, avgSpeed: nil, maxSpeed: nil, timeString: nil, withSpacers: true)
        }
        .padding()
        .background(Color.yellow)
    }
}
