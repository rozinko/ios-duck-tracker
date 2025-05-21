import SwiftUI
import MapKit

struct ActiveTrackScreen: View {

    @Binding var selectedTab: Int

    @State var activeTrackMapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.939, longitude: 30.315),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )

    @State var showFinishModalView = false
    @State var activeTrackTitle: String = ""
    @State var activeTrackType: ActiveTrackType

    private let liveActivityService = LiveActivityService.shared

    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        self.activeTrackType = DataProvider.shared.selectLastTrackType() ?? .run

        liveActivityService.setTrackType(self.activeTrackType)
    }

    var body: some View {
        VStack(spacing: 1) {
            ZStack(alignment: .top) {
                ActiveTrackMapView(activeTrackMapRegion: $activeTrackMapRegion)
                ActiveTrackFinishButtonView(showFinishModalView: $showFinishModalView)
            }
            ActiveTrackInfoView(activeTrackType: $activeTrackType)
            ActiveTrackStartPauseResumeButtonView()
        }
        .background(Color.commonBorder)
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showFinishModalView) {
            ActiveTrackFinishModalView(
                selectedTab: $selectedTab,
                showFinishModalView: $showFinishModalView,
                activeTrackTitle: $activeTrackTitle,
                activeTrackType: $activeTrackType)
        }
        .onAppear {
            liveActivityService.setTrackType(self.activeTrackType)
        }
        .onChange(of: $activeTrackType.wrappedValue, perform: { value in
            liveActivityService.updateActivity(trackType: value)
        })
    }
}

#Preview {
    ActiveTrackScreen(selectedTab: .constant(2))
}
