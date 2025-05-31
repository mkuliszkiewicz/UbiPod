## UbiPod

![UbiPod icon](https://github.com/mkuliszkiewicz/UbiPod/blob/main/UbiPod/Assets.xcassets/AppIcon.appiconset/180.png?raw=true)

### How to run the project?
- Since there are no 3rd party dependencies, just open the `UbiPod.xcodeproj` in `Xcode` and hit CMD + R

### Solution description
- API's used: https://rss.marketingtools.apple.com and https://itunes.apple.com/lookup
- This application presents the top podcasts for a few selected countries, you can change the selected country via the top right menu
- Deployment target is iOS 18+
- Offline mode support is achieved by querying the shared URL session `URLCache` in the event of "not connected" error. There are many ways to achieve this behaviour but I find this approach easy and understandable given the limited timeline  
- Parsing JSON into domain models directly is discouraged but I've decided to do it due to the small scale of the project
- I have written unit tests for all of the view models. In a production project I would also include the snapshot tests (https://github.com/pointfreeco/swift-snapshot-testing) 
- The application has basic light/dark mode support
- The application has basic accessibility support - can be used with VoiceOver
- It can be used on iPad
- I have extracted the project settings to the .xcconfig files, configuring the project in that way enables easier PR diffing and clarity