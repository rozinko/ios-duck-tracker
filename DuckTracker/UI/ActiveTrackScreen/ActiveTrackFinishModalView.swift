import SwiftUI

struct ActiveTrackFinishModalView: View {

    @Binding var selectedTab: Int
    @Binding var showFinishModalView: Bool
    @Binding var activeTrackTitle: String
    @Binding var activeTrackType: ActiveTrackType

    @ObservedObject var activeTrackProvider = ActiveTrackProvider.shared

    @State var showAlertWithoutSaving = false

    var trackFirstTimestamp: Date? { activeTrackProvider.track.trackPoints.first?.location.timestamp }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showFinishModalView = false
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.title3)
                        .accentColor(Color.commonTitle)
                })
            }

            Spacer()

            Group {
                Text("ActiveTrackFinishModalView.activeTrackTitleField".localized())
                    .foregroundColor(Color.commonText)
                TextField("", text: $activeTrackTitle)
                    .textFieldStyle(.roundedBorder)
            }

            Picker(".pickatype", selection: $activeTrackType) {
                ForEach(ActiveTrackType.allCases, id: \.self) { item in
                    item.getLabel(prefix: .full)
                }
            }
            .onChange(of: activeTrackType) { _ in
                for trackType in ActiveTrackType.allCases {
                    let defTitle = trackType.getDefaultTitle(firstTimestamp: trackFirstTimestamp)
                    if defTitle == activeTrackTitle {
                        activeTrackTitle = activeTrackType.getDefaultTitle(firstTimestamp: trackFirstTimestamp)
                    }
                }
            }
            .pickerStyle(.wheel)

            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    Button("ActiveTrackFinishModalView.saveAndFinish".localized(), action: {
                        activeTrackProvider.finish(title: activeTrackTitle, type: activeTrackType)
                        showFinishModalView = false
                        selectedTab = 1
                    })
                    .buttonStyle(ButtonOrangeFilledStyle())
                    .disabled(activeTrackTitle.isEmpty)
                }
                .font(.title3)

                HStack(spacing: 20) {
                    Button(".back".localized(), action: {
                        showFinishModalView = false
                    })

                    Button("ActiveTrackFinishModalView.finishWithoutSaving".localized(), action: {
                        showAlertWithoutSaving = true
                    })
                    .alert(isPresented: $showAlertWithoutSaving) {
                            Alert(
                                title: Text("ActiveTrackFinishModalView.alert.title".localized()),
                                message: Text("ActiveTrackFinishModalView.alert.message".localized()),
                                primaryButton: .destructive(
                                    Text("ActiveTrackFinishModalView.finishWithoutSaving".localized()),
                                    action: {
                                        showAlertWithoutSaving = false
                                        showFinishModalView = false
                                        activeTrackProvider.clear()
                                        activeTrackTitle = ""
                                    }
                                ),
                                secondaryButton: .cancel(
                                    Text(".back".localized())
                                )
                            )
                        }
                }
            }

            Spacer()
        }
        .padding(10)
        .onAppear {
            if activeTrackTitle == "" {
                activeTrackTitle = activeTrackType.getDefaultTitle(firstTimestamp: trackFirstTimestamp)
            }
        }
        .onDisappear {
            let defaultTitle = activeTrackType.getDefaultTitle(firstTimestamp: trackFirstTimestamp)
            if activeTrackTitle == defaultTitle {
                activeTrackTitle = ""
            }
        }
    }
}

struct ActiveTrackFinishModalView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackFinishModalView(
            selectedTab: .constant(2),
            showFinishModalView: .constant(true),
            activeTrackTitle: .constant(""),
            activeTrackType: .constant(.run))
        ActiveTrackFinishModalView(
            selectedTab: .constant(2),
            showFinishModalView: .constant(true),
            activeTrackTitle: .constant("New title for track"),
            activeTrackType: .constant(.electroscooter))
    }
}
