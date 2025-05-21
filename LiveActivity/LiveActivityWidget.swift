import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in

            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.widgetBackground.gradient)

                VStack {
                    HStack {
                        Text(context.state.isRecording ? context.state.trackType.getLocalized() : ".pause".localized())
                            .font(.title3.bold())
                            .foregroundStyle(.widgetTextPrimary)
                        Spacer()
                        Text(context.state.isRecording ? "Duck Tracker" : context.state.trackType.getLocalized())
                            .font(.title3)
                            .foregroundStyle(.widgetTextSecondary)
                    }

                    Spacer()

                    VStack {
                        HStack {
                            Image(systemName: "flag")
                            Spacer()
                            context.state.trackType.getIcon()
                        }

                        HStack(spacing: 4) {
                            Circle()
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                            Circle()
                        }
                        .frame(height: 7)

                        HStack {
                            Text(context.attributes.startDate.toStringHHmm())
                            Spacer()
                            Text(context.state.distance.prepareString())
                            Spacer()
                            Text(context.state.lastDate.toStringHHmm())
                        }
                        .font(.caption2)
                    }
                    .foregroundStyle(.widgetTextPrimary)
                }
                .padding(15)

            }
            .activityBackgroundTint(Color.widgetBackground)
            .activitySystemActionForegroundColor(Color.widgetTextPrimary)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {}
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {}
                }
                DynamicIslandExpandedRegion(.bottom) {

                    VStack {
                        HStack {
                            Text(context.state.isRecording ? context.state.trackType.getLocalized() : ".pause".localized())
                                .font(.title3.bold())
                                .foregroundStyle(.diPrimary)
                            Spacer()
                            Text(context.state.isRecording ? "" : context.state.trackType.getLocalized())
                                .font(.title3)
                                .foregroundStyle(.diSecondary)
                        }

                        Spacer()

                        VStack {
                            HStack {
                                Image(systemName: "flag")
                                Spacer()
                                context.state.trackType.getIcon()
                            }
                            .foregroundStyle(.diTimeline)

                            HStack(spacing: 4) {
                                Circle()
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                Circle()
                            }
                            .frame(height: 7)
                            .foregroundStyle(.diTimeline)

                            HStack {
                                Text(context.attributes.startDate.toStringHHmm())
                                Spacer()
                                Text(context.state.distance.prepareString())
                                Spacer()
                                Text(context.state.lastDate.toStringHHmm())
                            }
                            .font(.caption2)
                            .foregroundStyle(.diTimeline)
                        }.padding([.top, .bottom], 3)

                        HStack {
                            Spacer()
                            Text("Duck Tracker")
                                .font(.caption2)
                                .foregroundStyle(.diSecondary)
                            Spacer()
                        }
                    }

                }
            } compactLeading: {

                Image(systemName: context.state.isRecording ? context.state.trackType.getSystemImageName() : "pause.circle")
                    .foregroundStyle(Color.diCompact)

            } compactTrailing: {

                Text(context.state.distance.prepareString(compact: true))
                    .foregroundStyle(Color.diCompact)

            } minimal: {

                Image(systemName: context.state.isRecording ? context.state.trackType.getSystemImageName() : "pause.circle")
                    .foregroundStyle(Color.diCompact)

            }
            .keylineTint(Color.diCompact)
        }
    }

}

extension LiveActivityAttributes {
    fileprivate static var preview: LiveActivityAttributes {
        LiveActivityAttributes(startDate: .now - TimeInterval(3600))
    }
}

extension LiveActivityAttributes.ContentState {
    fileprivate static var one: LiveActivityAttributes.ContentState {
        LiveActivityAttributes.ContentState(isRecording: true, trackType: .bike, distance: 6700, lastDate: .now)
     }

    fileprivate static var two: LiveActivityAttributes.ContentState {
        LiveActivityAttributes.ContentState(isRecording: true, trackType: .hike, distance: 12350, lastDate: .now)
     }

    fileprivate static var three: LiveActivityAttributes.ContentState {
        LiveActivityAttributes.ContentState(isRecording: true, trackType: .car, distance: 127890, lastDate: .now)
     }

     fileprivate static var four: LiveActivityAttributes.ContentState {
         LiveActivityAttributes.ContentState(isRecording: false, trackType: .train, distance: 176599, lastDate: .now)
     }
}

#Preview("Notification", as: .content, using: LiveActivityAttributes.preview) {
   LiveActivityWidget()
} contentStates: {
    LiveActivityAttributes.ContentState.one
    LiveActivityAttributes.ContentState.two
    LiveActivityAttributes.ContentState.three
    LiveActivityAttributes.ContentState.four
}
