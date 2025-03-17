import SwiftUI
import MapKit

struct HistoryTrackInfoWithPreloaderView: View {

    let shortTrack: ShortTrack

    let dataProvider = DataProvider.shared
    let coreDataProvider = CoreDataProvider.shared

    @Environment(\.presentationMode) var presentationMode

    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.939, longitude: 30.315),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )

    @State var fullTrack: InfoTrack?
    @State var showEditModal = false
    @State var showDeleteAlert = false

    @State var selectedPoint: Int?

    init(shortTrack: ShortTrack) {
        print("HistoryTrackInfoWithPreloaderView // init(): \(shortTrack.title)")
        self.shortTrack = shortTrack
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 1) {

                // Иконка типа поездки и дата поездки
                HStack(spacing: 10) {
                    Spacer()
                    self.shortTrack.type.getIcon()
                    Text(self.shortTrack.timeIntervalString)
                    Spacer()
                }
                .padding(.bottom, 5)
                .background(Color.commonElementBackground)

                // Карта поездки
                if fullTrack != nil {
                    HistoryTrackMapView(selectedPoint: $selectedPoint, region: $region, trackCoordinates: fullTrack?.route.coordinates ?? [])
                        .frame(height: UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale)
                        .onAppear {
                            print("HistoryTrackMapView // onAppear{} dots: \(fullTrack?.route.coordinates.count ?? 0)")
                        }
                        .onDisappear {
                            print("HistoryTrackMapView // onDisappear{}")
                        }
                } else {
                    VStack {
                        Spacer()
                        VStack(spacing: 10) {
                            ProgressView()
                            HStack {
                                Spacer()
                                Text(".loading".localized()).font(Font.title2.bold())
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .background(Color.commonBackground)
                    .frame(height: UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale)
                }

                // Параметры скорости дистанции и тд
                TrackInfoFullView(
                    distance: shortTrack.distance,
                    avgSpeed: shortTrack.avgSpeed,
                    maxSpeed: shortTrack.maxSpeed,
                    uphill: fullTrack?.upHill,
                    timeString: shortTrack.getTimeAsString(),
                    paceString: shortTrack.getPaceAsString(),
                    withSpacers: false
                )

                // Графики
                HistoryTrackInfoChartsView(selectedPoint: $selectedPoint, points: fullTrack?.route.points, avgSpeed: shortTrack.avgSpeed.toKmh())

            }
        }
        .background(Color.commonBorder)
        .navigationTitle(shortTrack.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    if fullTrack != nil {
                        Button(action: {
                            // open share window for export GPX file
                            let gpxURL = DuckFileManager.getGPXFileURL(infoTrack: fullTrack!)
                            let activityController = UIActivityViewController(activityItems: [gpxURL!], applicationActivities: nil)
                            UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                        }, label: {
                            Text(".exportGPX")
                        })
                    }

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
            if fullTrack != nil {
                HistoryTrackInfoEditModalView(showModalView: $showEditModal, infoTrack: fullTrack!, prevPresentationMode: presentationMode)
            }
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
                        if fullTrack != nil {
                            _ = dataProvider.deleteTrack(infoTrack: fullTrack)
                        }
                        // going back
                        self.presentationMode.wrappedValue.dismiss()
                    }
                ),
                secondaryButton: .cancel(
                    Text(".back".localized())
                )
            )
        }
        .onAppear {
            let methodStart = Date()
            coreDataProvider.selectById(trackId: shortTrack.id, { [methodStart] cdTracks in
                for cdTrack in cdTracks where cdTrack.id == shortTrack.id {
                    fullTrack = InfoTrack(fromCoreDataTrack: cdTrack)
                }
                if fullTrack != nil {
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: fullTrack!.centerLatitude,
                            longitude: fullTrack!.centerLongitude),
                        span: MKCoordinateSpan(
                            latitudeDelta: fullTrack!.latitudeDelta,
                            longitudeDelta: fullTrack!.longitudeDelta)
                    )
                }
                let executionTime = Int(Date().timeIntervalSince(methodStart) * 1000)
                print("HistoryTrackInfoWithPreloaderView // onAppear selectById(): Execution time: \(executionTime) ms")
            })
        }
        .onDisappear {
            print("HistoryTrackInfoWithPreloaderView // onDisappear()")
        }
    }
}
