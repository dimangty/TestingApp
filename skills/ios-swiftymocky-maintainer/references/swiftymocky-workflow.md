# SwiftyMocky Workflow (TestingTask)

## Files to Keep in Sync

1. `Mockfile`
2. `TestingTaskTests/ScreenMockables.swift`
3. `TestingTaskTests/Support/Generated/Mock.generated.swift`

## Wrapper File Template

`ScreenMockables.swift` should contain protocol wrappers only:

```swift
import Foundation
import UIKit
@testable import TestingTask

//sourcery: AutoMockable
protocol LoginScreenViewInputMockable: LoginScreenViewInput {}

//sourcery: AutoMockable
protocol LoginScreenRouterInputMockable: LoginScreenRouterInput {}
```

Keep wrappers one-line and avoid custom logic inside this file.

## Common Wrappers for This Project

1. `ArticleViewInputMockable: ArticleViewInput`
2. `ArticleRouterInputMockable: ArticleRouterInput`
3. `AuthServiceProtocolMockable: AuthServiceProtocol`
4. `FavoriteViewInputMockable: FavoriteViewInput`
5. `FavoriteRouterInputMockable: FavoriteRouterInput`
6. `LoginScreenViewInputMockable: LoginScreenViewInput`
7. `LoginScreenRouterInputMockable: LoginScreenRouterInput`
8. `NewsViewInputMockable: NewsViewInput`
9. `NewsRouterInputMockable: NewsRouterInput`
10. `SignUpScreenViewInputMockable: SignUpScreenViewInput`
11. `SignUpScreenRouterInputMockable: SignUpScreenRouterInput`

## Generation

Run from repository root:

```bash
bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh .
```

## Failure Modes

1. `Type ...Mock not found`: wrapper missing or generation not executed.
2. `Verify/Perform signature mismatch`: protocol changed, mocks stale.
3. `swiftymocky` binary missing: install or use `/tmp/SwiftyMocky/bin/swiftymocky`.

## Review Checklist

1. Wrapper file has the required protocols.
2. Generated file contains corresponding `...Mock` classes.
3. No unrelated files changed.
