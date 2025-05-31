enum LoadingState<T: Hashable>: Hashable {
    case idle
    case loading
    case loaded(T)
    case failed

    var content: T? {
        switch self {
        case .idle, .failed, .loading: nil
        case .loaded(let content): content
        }
    }
}
