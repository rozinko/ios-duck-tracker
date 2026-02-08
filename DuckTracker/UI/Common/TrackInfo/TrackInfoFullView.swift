import SwiftUI
import MapKit

struct TrackInfoFullView: View {

    let distance: CLLocationDistance?
    let avgSpeed: CLLocationSpeed?
    let maxSpeed: CLLocationSpeed?
    let uphill: CLLocationDistance?
    let timeString: String?
    let paceString: String?
    let withSpacers: Bool

    var body: some View {
        HStack(spacing: 1) {
            VStack(spacing: 1) {
                TrackInfoElementView(
                    title: ".pace".localized().uppercased(),
                    text: paceString,
                    rightSpacer: withSpacers,
                    position: .topLeading
                )
                TrackInfoElementView(
                    title: ".avgspeed".localized().uppercased(),
                    text: avgSpeed?.prepareStringKmh(),
                    rightSpacer: withSpacers
                )
                TrackInfoElementView(
                    title: ".maxspeed".localized().uppercased(),
                    text: maxSpeed?.prepareStringKmh(),
                    rightSpacer: withSpacers,
                    position: .bottomLeading
                )
            }

            VStack(spacing: 1) {
                TrackInfoElementView(
                    title: ".uphill".localized().uppercased(),
                    text: uphill?.prepareString(),
                    leftSpacer: withSpacers,
                    position: .topTrailing
                )
                TrackInfoElementView(
                    title: ".time".localized().uppercased(),
                    text: timeString,
                    leftSpacer: withSpacers
                )
                TrackInfoElementView(
                    title: ".distance".localized().uppercased(),
                    text: distance?.prepareString(),
                    leftSpacer: withSpacers,
                    position: .bottomTrailing
                )
            }
        }
    }
}

struct TrackInfoFullView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            TrackInfoFullView(distance: 123.4, avgSpeed: 12.34, maxSpeed: 123.4, uphill: 235.1, timeString: "01:00:59", paceString: "05:12", withSpacers: true)

            TrackInfoFullView(distance: 12.42, avgSpeed: 12.34, maxSpeed: 123.4, uphill: 12235.1, timeString: "12:01:59", paceString: "05:12", withSpacers: false)

            TrackInfoFullView(distance: nil, avgSpeed: nil, maxSpeed: nil, uphill: nil, timeString: nil, paceString: nil, withSpacers: true)
        }
        .padding()
        .background(Color.yellow)
    }
}
