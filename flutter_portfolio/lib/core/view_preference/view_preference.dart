import 'view_preference_stub.dart'
    if (dart.library.js_interop) 'view_preference_web.dart' as platform;

/// Which portfolio view is shown: the Apple-theme developer site or the
/// simple, non-technical portfolio.
enum PortfolioView { developer, simple }

/// `?view=simple` opens the simple view; anything else (`?view=developer`,
/// the older `?view=apple`, or no parameter) opens the developer view.
PortfolioView readInitialView() => platform.readViewFromUrl() == 'simple'
    ? PortfolioView.simple
    : PortfolioView.developer;

/// Reflects [view] in the URL (`?view=developer` / `?view=simple`) so the
/// link can be shared.
void persistView(PortfolioView view) =>
    platform.persistView(view == PortfolioView.simple ? 'simple' : 'developer');
