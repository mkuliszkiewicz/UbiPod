## UbiPod

### Solution description
- API's used: https://rss.marketingtools.apple.com and https://itunes.apple.com/lookup
- This application presents the top podcasts for a few selected countries, you can change the selected country via the top right menu
- Mobile app to list and play the top podcasts per country (only few selected ones)
- Deployment target is iOS 18+
- Offline mode support is achieved by querying the shared URL session `URLCache` in the event of "not connected" error 
- Parsing JSON into domain models directly is discouraged but I've decided to do it due to the small scale of the project
- I have written unit tests for all of the view models. In a production project I would also include the snapshot tests (https://github.com/pointfreeco/swift-snapshot-testing).   
- This application supports light/dark mode

