import SwiftUI
import MapKit

struct HistoryTrackInfoView: View {

    private let infoTrack: InfoTrack

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var dataProvider = DataProvider.shared

    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.939, longitude: 30.315),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )

    @State var showMap = false
    @State var showEditModal = false
    @State var showDeleteAlert = false

    @State var infoTrackTitleForRename: String = ""

    var routeCoordinates: [CLLocationCoordinate2D] { infoTrack.route.coordinates }

    init(infoTrack: InfoTrack) {
        self.infoTrack = infoTrack
        self.infoTrackTitleForRename = infoTrack.title
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 1) {

                HStack(spacing: 10) {
                    Spacer()
                    self.infoTrack.type.getIcon()
                    Text(self.infoTrack.timeIntervalString)
                    Spacer()
                }
                .padding(.bottom, 5)
                .background(Color.commonElementBackground)

                if self.showMap {
                    HistoryTrackMapView(region: $region, trackCoordinates: routeCoordinates)
                        .frame(height: UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale)
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(".loading".localized()).font(Font.title2.bold())
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(Color.commonBackground)
                    .frame(height: UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale)
                }

                TrackInfoFullView(
                    distance: infoTrack.distance,
                    avgSpeed: infoTrack.avgSpeed,
                    maxSpeed: infoTrack.maxSpeed,
                    uphill: infoTrack.upHill,
                    timeString: infoTrack.getTimeAsString(),
                    paceString: infoTrack.getPaceAsString(),
                    withSpacers: false
                )

                HistoryTrackInfoChartsView(points: infoTrack.route.points, avgSpeed: infoTrack.avgSpeed)
            }
            .background(Color.commonBorder)
            .navigationTitle(infoTrack.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button(action: {
                            // show modal with title and type fields
                            showEditModal = true
                        }, label: {
                            Text(".edit")
                        })

                        Button(action: {
                            // show alert
                            showDeleteAlert = true
                        }, label: {
                            Text(".delete")
                        })
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                    })
                }
            }
            .sheet(isPresented: $showEditModal) {
                HistoryTrackInfoEditModalView(showModalView: $showEditModal, infoTrack: infoTrack, prevPresentationMode: presentationMode)
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("HistoryTrackInfoView.deleteAlert.title".localized()),
                    message: Text("HistoryTrackInfoView.deleteAlert.message".localized()),
                    primaryButton: .destructive(
                        Text("HistoryTrackInfoView.deleteAlert.button".localized()),
                        action: {
                            // hide alert
                            showDeleteAlert = false
                            // deleting
                            _ = dataProvider.deleteTrack(infoTrack: infoTrack)
                            // going back
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    ),
                    secondaryButton: .cancel(
                        Text(".back".localized())
                    )
                )
            }
        }
        .onAppear {
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: infoTrack.centerLatitude, longitude: infoTrack.centerLongitude),
                span: MKCoordinateSpan(latitudeDelta: infoTrack.latitudeDelta, longitudeDelta: infoTrack.longitudeDelta)
            )

            self.showMap = true
        }
    }
}
