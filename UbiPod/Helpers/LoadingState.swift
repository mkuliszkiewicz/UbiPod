enum LoadingState<T: Hashable>: Hashable {
    case idle
    case loading
    case loaded(T)
    case failed
}
