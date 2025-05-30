// See https://github.com/pointfreeco/swiftui-navigation/blob/main/Sources/SwiftUINavigation/HashableObject.swift
// It allows to have view models as navigation destinations
protocol HashableObject: AnyObject, Hashable {}

extension HashableObject {
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs === rhs }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(ObjectIdentifier(self))
  }
}
