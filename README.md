## UbiPod

![UbiPod icon](https://github.com/mkuliszkiewicz/UbiPod/blob/main/UbiPod/Assets.xcassets/AppIcon.appiconset/180.png?raw=true)

### How to run the project?
- Since there are no third-party dependencies, just open `UbiPod.xcodeproj` in `Xcode` and press **CMD + R**.

### Solution description
- **APIs used**: [Apple RSS Feed](https://rss.marketingtools.apple.com) and [iTunes Lookup](https://itunes.apple.com/lookup)
- This application displays the top podcasts for a few selected countries. You can change the selected country using the menu in the top-right corner.
- **Deployment target**: iOS 18+
- **Offline mode** is supported by querying the shared URL session's `URLCache` in case of a "not connected" error. There are many ways to implement this behavior, but I find this approach simple and understandable given the limited timeline.
- Parsing JSON directly into domain models is generally discouraged, but I chose this approach due to the small scale of the project.
- I have written **unit tests** for all view models. In a production project, I would also include views snapshot tests using [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing).
- The application supports dark mode
- **Basic accessibility** is supported, the app can be used with VoiceOver.
- The app is compatible with **iPad** but no iPad specific UI adjustments were made