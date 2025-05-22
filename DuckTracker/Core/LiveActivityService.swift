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

    public func updateActivity(
        isRecording isRec: Bool? = nil,
        trackType type: ActiveTrackType? = nil,
        distance dist: CLLocationDistance? = nil,
        lastDate date: Date? = nil
    ) {
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
