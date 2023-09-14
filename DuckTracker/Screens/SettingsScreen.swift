import SwiftUI

struct SettingsScreen: View {

    @Binding var selectedTab: Int

    var body: some View {

        Text("Settings Screen")

    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(selectedTab: .constant(4))
    }
}
