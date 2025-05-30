## UbiPod

### Task description
`Please write a small app that fetches data from the web and displays it in a list. Pressing on the list item should present a new screen containing details for the selected item. You are allowed to use any public API you like for the content data. The app should be implemented using native Apple frameworks only, i.e. no third party dependencies. Please use SwiftUI for the UI. No fancy UI is expected, but an attention to detail is advisable. A data cache should be included, so that the app can be used without internet connection (excluding the first launch, obviously). Tests are not required but will be considered as a nice extra. Please share your solution via GitHub by providing a link to it.`

### Good to know

- https://rss.marketingtools.apple.com - API
- Mobile app to list and play the top podcasts per country
- Supports only iPhone in portrait
- Deployment target is iOS 18+
- Offline mode support (to browse the top podcasts)
- I am not mapping response models to domain models 
        // Important note:
        // In a real life scenario a domain mapping here would occur, so I would map response objects
        // to the local domain objects. But due to the time constraint I've decided to skip it.
