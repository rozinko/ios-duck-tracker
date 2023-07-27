import SwiftUI

struct MainInformerView: View {

    @Binding var selectedTab: Int

    @ObservedObject var dataProvider = DataProvider.shared
    @ObservedObject var locationProvider = LocationProvider.shared

    var body: some View {
        if locationProvider.locationStatus <= 1 {
            MainInformerNeedRequestView()
        } else if locationProvider.locationStatus <= 2 {
            MainInformerDeniedView()
        } else if dataProvider.tracks.isEmpty {
            MainInformerFirstTrackView(selectedTab: $selectedTab)
        } else {
            VStack {}
        }

    }

}

struct MainInformerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            MainInformerNeedRequestView()

            MainInformerDeniedView()

            MainInformerFirstTrackView(selectedTab: .constant(1))
        }
        .padding()
    }
}
