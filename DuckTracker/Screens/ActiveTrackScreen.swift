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
        if #available(iOS 26.0, *) {
            ZStack(alignment: .top) {
                ActiveTrackMapView(activeTrackMapRegion: $activeTrackMapRegion)
                    .edgesIgnoringSafeArea(.all)

                ActiveTrackFinishButtonView(showFinishModalView: $showFinishModalView)

                VStack(spacing: 5) {
                    Spacer()
                    ActiveTrackInfoView(activeTrackType: $activeTrackType)
                    ActiveTrackStartPauseResumeButtonView()
                }
                .padding()
            }
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
        } else {
            ZStack(alignment: .top) {
                ActiveTrackMapView(activeTrackMapRegion: $activeTrackMapRegion)
                    .edgesIgnoringSafeArea([.leading, .top, .trailing])

                ActiveTrackFinishButtonView(showFinishModalView: $showFinishModalView)
                    .padding()

                VStack(spacing: 5) {
                    Spacer()
                    ActiveTrackInfoView(activeTrackType: $activeTrackType)
                    ActiveTrackStartPauseResumeButtonView()
                }
                .padding()
            }
            .background(Color.commonBorder)
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
}

#Preview {
    ActiveTrackScreen(selectedTab: .constant(2))
}
