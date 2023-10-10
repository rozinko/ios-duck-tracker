import SwiftUI

struct WhatsNewScreen: View {

    @Binding var showModal: Bool

    @State var tabViewSelection: Int = 0

    private let whatsNewProvider = WhatsNewProvider.shared

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showModal = false
                    whatsNewProvider.closeWhatsNew()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.title3)
                        .accentColor(Color.commonTitle)
                })
            }

            VStack(spacing: 20) {
                Text("WhatsNewScreen.title".localized()).font(Font.title.bold())

                TabView(selection: $tabViewSelection) {

                    ForEach(whatsNewProvider.updates, id: \.self) { element in
                        VStack {
                            Text(element.title.localized())
                                .font(Font.title)
                                .multilineTextAlignment(TextAlignment.center)
                                .frame(width: 300)
                            Image(element.imageName)
                            Text(element.description.localized())
                                .font(Font.body)
                                .multilineTextAlignment(TextAlignment.center)
                                .frame(width: 300)
                            Spacer()
                        }.tag(element.tag)
                    }

                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                Spacer()

                if tabViewSelection < whatsNewProvider.updates.count - 1 {
                    Button("Далее") {
                        tabViewSelection += 1
                    }.buttonStyle(ButtonOrangeFilledBlockStyle())
                } else {
                    Button("Завершить") {
                        showModal = false
                        whatsNewProvider.closeWhatsNew()
                    }.buttonStyle(ButtonOrangeFilledBlockStyle())
                }

//                HStack {
//                    Spacer()
//                    Button("Назад") { }
//                    Spacer()
//                }
            }
        }.padding(10)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView(selectedTab: 1, showWhatsNewModal: true)
    }
}
