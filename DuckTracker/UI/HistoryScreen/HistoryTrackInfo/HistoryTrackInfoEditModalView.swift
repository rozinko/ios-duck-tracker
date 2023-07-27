import SwiftUI

struct HistoryTrackInfoEditModalView: View {

    @Binding var showModalView: Bool
    var infoTrack: InfoTrack
    @Binding var prevPresentationMode: PresentationMode

    var dataProvider = DataProvider.shared

    @State var trackTitle: String = ""
    @State var trackType: ActiveTrackType = .other

    let colorButtonsText = Color.commonWhite
    let colorFinishButtonBackground = Color.commonOrange

    init(showModalView: Binding<Bool>, infoTrack: InfoTrack, prevPresentationMode: Binding<PresentationMode>) {
        self._showModalView = showModalView

        self.infoTrack = infoTrack

        self._prevPresentationMode = prevPresentationMode

        self.trackTitle = infoTrack.title
        self.trackType = infoTrack.type
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showModalView = false
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.title3)
                        .accentColor(Color.commonTitle)
                })
            }

            Spacer()

            Group {
                Text(".title".localized())
                    .foregroundColor(.secondary)
                TextField("", text: $trackTitle)
                    .textFieldStyle(.roundedBorder)
            }

            Picker("Pick a type", selection: $trackType) {
                ForEach(ActiveTrackType.allCases, id: \.self) { item in
                    item.getLabel(prefix: .full)
                }
            }
            .pickerStyle(.wheel)

            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    Button(".back".localized(), action: {
                        showModalView = false
                    })
                    Button(".save".localized(), action: {
                        showModalView = false
                        // save!
                        _ = dataProvider.updateTrack(infoTrack: infoTrack, title: trackTitle, type: trackType)
                        // go back to list
                        prevPresentationMode.dismiss()
                    })
                    .disabled(trackTitle.isEmpty)
                }
            }

            Spacer()
        }
        .padding(10)
        .onAppear {
            self.trackTitle = infoTrack.title
            self.trackType = infoTrack.type
        }
    }
}
