import Foundation
import CoreLocation
import ActivityKit

class LiveActivityService {

    static let shared = LiveActivityService()

    // content state
    private var trackType: ActiveTrackType = .other
    private var contentState: LiveActivityAttributes.ContentState?

    @available(iOS 16.1, *)
    private var isEnabled: Bool {
        return ActivityAuthorizationInfo().areActivitiesEnabled
    }

    @available(iOS 16.1, *)
    private var activities: [Activity<LiveActivityAttributes>] {
        return Activity<LiveActivityAttributes>.activities
    }

    @available(iOS 16.1, *)
    private var isActive: Bool {
        return !self.activities.isEmpty
    }

    @available(iOS 16.1, *)
    private var activity: Activity<LiveActivityAttributes>? {
        return self.activities.first
    }

    private init() { }

    public func hasActivity() -> Bool {
        guard #available(iOS 16.1, *) else { return false }
        return isActive
    }

    public func startActivity(startDate: Date) {
        guard #available(iOS 16.1, *), isEnabled else { return }

        let attributes = LiveActivityAttributes(startDate: startDate)
        let contentState = LiveActivityAttributes.ContentState(isRecording: true, trackType: self.trackType, distance: 0, lastDate: .now)

        do {
            let activity = try Activity<LiveActivityAttributes>.request(attributes: attributes, contentState: contentState)

            self.contentState = contentState

            print("LiveActivityService: \(activity.id) Live Activity created.")
        } catch {
            print("LiveActivityService: Error when make new Live Activity: \(error.localizedDescription).")
        }
    }
    
    public func setTrackType(_ trackType: ActiveTrackType) {
        self.trackType = trackType
    }

    public func updateActivity(isRecording isRec: Bool? = nil, trackType type: ActiveTrackType? = nil, distance dist: CLLocationDistance? = nil, lastDate date: Date? = nil) {
        guard #available(iOS 16.1, *), isEnabled else { return }
        guard let activity = self.activity else { return }
        guard var state = self.contentState else { return }

        var needUpdate = false

        if isRec != nil && state.isRecording != isRec {
            state.isRecording = isRec ?? false
            needUpdate = true
        }

        if type != nil && state.trackType != type {
            state.trackType = type ?? .other
            needUpdate = true
        }

        if dist != nil && state.distance != dist {
            if state.distance.prepareString() != dist?.prepareString() {
                needUpdate = true
            }
            state.distance = dist ?? 0
        }

        if date != nil && state.lastDate != date {
            if state.lastDate.toStringHHmm() != date?.toStringHHmm() {
                needUpdate = true
            }
            state.lastDate = date ?? Date()
        }

        guard needUpdate else { return }

        self.contentState = state

        Task {
            await activity.update(using: state)
        }
    }

    @available(iOS 16.1, *)
    private func stopActivity(_ activity: Activity<LiveActivityAttributes>) {
        Task {
            await activity.end(dismissalPolicy: .immediate)
        }
    }

    public func stopActivites() {
        guard #available(iOS 16.1, *) else { return }

        for activity in self.activities {
            stopActivity(activity)
        }
    }

}

// enum LiveActivityService {
//
//    static var isEnabled: Bool {
//        return ActivityAuthorizationInfo().areActivitiesEnabled
//    }
//
//    static var activities: [Activity<LiveActivityAttributes>] {
//        return Activity<LiveActivityAttributes>.activities
//    }
//
//    static func makeActivity(trackType: ActiveTrackType, startDate: Date, isRecording: Bool, distance: CLLocationDistance, lastDate: Date) {
//        guard isEnabled else { return }
//
//        // Using only when make new Live Activity
//        let attributes = LiveActivityAttributes(startDate: startDate)
//
//        // Can be used for update Live activity later with other values
//        let contentState = LiveActivityAttributes.ContentState(isRecording: isRecording, trackType: trackType, distance: distance, lastDate: lastDate)
//
//        do {
//            let activity = try Activity<LiveActivityAttributes>.request(
//                attributes: attributes,
//                contentState: contentState
//            )
//
//            // For update by pushes you must have token
//            // activity.pushToken
//
//            print("LiveActivityService: \(activity.id) Live Activity created.")
//        } catch {
//
//            // You must to handle errors. It may happen:
//            // 1. User lock Live Activity for application.
//            // 2. Reached limit of Live Activities for system.
//            print("LiveActivityService: Error when make new Live Activity: \(error.localizedDescription).")
//        }
//    }
//
////    static func updateActivity(_ activity: Activity<LiveActivityAttributes>, value: String) {
////        
////        // We can update only with `ContentState`.
////        let contentState = LiveActivityAttributes.ContentState(emoji: "E")
////        Task {
////            await activity.update(using: contentState)
////        }
////    }
//
//    static func endActivity(_ activity: Activity<LiveActivityAttributes>) {
//
//        // 1. For close Live Activity immediate.
//        // It close Live Activity right now.
//        Task {
//            await activity.end(dismissalPolicy: .immediate)
//        }
//
//        /*
//        // 2. If you want show user some action completed.
//        // Live Activity closed when user saw it or maximum in 4 hours by system.
//        let contentState = ActivityAttribute.ContentState(dynamicStringValue: "Finished", dynamicIntValue: 2, dynamicBoolValue: true)
//        Task {
//            await activity.end(using: contentState, dismissalPolicy: .default)
//        }
//         */
//    }
//}
