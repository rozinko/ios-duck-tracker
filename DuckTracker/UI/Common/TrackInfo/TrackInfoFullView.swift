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
        VStack(spacing: 1) {
            HStack(spacing: 1) {
                VStack(spacing: 1) {
                    TrackInfoElementView(
                        title: ".pace".localized().uppercased(),
                        text: paceString,
                        rightSpacer: withSpacers
                    )
                }
                VStack(spacing: 1) {
                    TrackInfoElementView(
                        title: ".uphill".localized().uppercased(),
                        text: uphill?.prepareString(),
                        leftSpacer: withSpacers
                    )
                }
            }

            TrackInfoCommonView(
                distance: distance,
                avgSpeed: avgSpeed,
                maxSpeed: maxSpeed,
                timeString: timeString,
                withSpacers: withSpacers)
        }
    }
}

struct TrackInfoFullView_Previews: PreviewProvider {
    static var previews: some View {
        TrackInfoFullView(distance: 123.4, avgSpeed: 12.34, maxSpeed: 123.4, uphill: 235.1, timeString: "01:00:59", paceString: "05:12", withSpacers: true)
            .background(Color.gray)
        TrackInfoFullView(distance: 12.42, avgSpeed: 12.34, maxSpeed: 123.4, uphill: 12235.1, timeString: "12:01:59", paceString: "05:12", withSpacers: false)
            .background(Color.gray)
        TrackInfoFullView(distance: nil, avgSpeed: nil, maxSpeed: nil, uphill: nil, timeString: nil, paceString: nil, withSpacers: true)
            .background(Color.gray)
    }
}
