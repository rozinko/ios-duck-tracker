import SwiftUI
import MapKit

enum HistoryTrackInfoDataTab: String, CaseIterable {
    case main, speed, altitude, distance

    var title: String {
        switch self {
        case .main:
            return ".data".localized()
        case .speed:
            return ".speed".localized()
        case .altitude:
            return ".altitude".localized()
        case .distance:
            return ".distance".localized()
        }
    }
}

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
    @State var selectedDataTab: HistoryTrackInfoDataTab = .main
    @State var selectedChartTab: DuckTrackChartVisible = .speed

    var dataTabShape: any Shape {
        if #available(iOS 26.0, *) {
            return .capsule
        } else {
            return RoundedRectangle(cornerRadius: 7.5)
        }
    }

    var dataTabMainOffset: CGFloat { selectedDataTab == .main ? 0 : -UIScreen.main.nativeBounds.width }
    var dataTabChartsOffset: CGFloat { selectedDataTab == .main ? UIScreen.main.nativeBounds.width : 0 }

    var chartModel: DuckTrackChartModel {
        DuckTrackChartModel(
            data: fullTrack?.route.points.map { DuckTrackChartPoint(speed: $0.speed, altitude: $0.altitude, distance: $0.distance, date: $0.timestamp) },
            avgSpeed: fullTrack?.avgSpeed ?? 0
        )
    }

    init(shortTrack: ShortTrack) {
        print("HistoryTrackInfoWithPreloaderView // init(): \(shortTrack.title)")
        self.shortTrack = shortTrack
    }

    var body: some View {
        VStack(spacing: 1) {

            ZStack {
                // Карта поездки
                if fullTrack != nil {
                    if #available(iOS 26.0, *) {
                        HistoryTrackMapView(selectedPoint: $selectedPoint, region: $region, trackCoordinates: fullTrack?.route.coordinates ?? [])
                            .ignoresSafeArea()
                    } else {
                        HistoryTrackMapView(selectedPoint: $selectedPoint, region: $region, trackCoordinates: fullTrack?.route.coordinates ?? [])
                    }
                } else {
                    LoadingView()
                        .background(Color.commonBackground)
                }

                VStack {
                    // Иконка типа поездки и дата поездки
                    HStack(spacing: 10) {
                        self.shortTrack.type.getIcon()
                        Text(self.shortTrack.timeIntervalString)
                    }
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], 15)
                    .modifier(LiquidGlassModifier(glassShape: .capsule, shape: .capsule))

                    Spacer()

                    ZStack {
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
                            .offset(x: dataTabMainOffset)
                            .animation(Animation.easeInOut(duration: 0.5), value: dataTabMainOffset)

                        DuckTrackChartsView(selectedPoint: $selectedPoint, chartModel: chartModel, visible: selectedChartTab)
                            .modifier(LiquidGlassModifier(glassShape: .rect(cornerRadius: 15), shape: .rect(cornerRadius: 15)))
                            .offset(x: dataTabChartsOffset)
                            .animation(Animation.easeInOut(duration: 0.5), value: dataTabChartsOffset)
                    }
//                    .frame(width: UIScreen.main.nativeBounds.width * 2, alignment: .leading)

                    VStack {
                        Picker("Data tab", selection: $selectedDataTab) {
                            ForEach(HistoryTrackInfoDataTab.allCases, id: \.self) { tab in
                                Text(tab.title).tag(tab.rawValue)
                            }
                        }
                        .onChange(of: selectedDataTab) { newValue in
                            switch newValue {
                            case .main:
                                break
                            case .speed:
                                selectedChartTab = .speed
                            case .altitude:
                                selectedChartTab = .altitude
                            case .distance:
                                selectedChartTab = .distance
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(0)
                    .modifier(LiquidGlassModifier(glassShape: dataTabShape, shape: dataTabShape))
                }
                .padding([.top], 5)
                .padding([.leading, .trailing, .bottom], 15)
            }

            // Графики
//                HistoryTrackInfoChartsView(selectedPoint: $selectedPoint, points: fullTrack?.route.points, avgSpeed: shortTrack.avgSpeed.toKmh())

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
