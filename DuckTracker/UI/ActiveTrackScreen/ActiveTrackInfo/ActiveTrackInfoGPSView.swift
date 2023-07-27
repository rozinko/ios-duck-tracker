import SwiftUI

struct ActiveTrackInfoGPSView: View {

    @ObservedObject private var locationProvider = LocationProvider.shared

    var body: some View {
        let acc = locationProvider.userLocation != nil ? Int(locationProvider.userLocation!.horizontalAccuracy) : 0
        let color: Color = acc <= 10 && acc > 0 ? .commonInformerSuccess : (acc <= 30 && acc > 0 ? .commonInformerWarning : .commonInformerDanger)

        HStack(spacing: 5) {
            Image(systemName: "dot.radiowaves.left.and.right")
            Text(".gps".localized())
                .fontWeight(.semibold)
        }
        .foregroundColor(color)
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 22)
        .padding(5)
        .background(Color.commonElementBackground)
    }
}

struct TrackGPS_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackInfoGPSView()
    }
}
