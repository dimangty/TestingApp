# SwiftyMocky Setup (Qwen / TestingTask)

## 1. Prerequisites

1. Install [Mint](https://github.com/yonaskolb/Mint) if missing.
2. Install SwiftyMocky CLI via Mint:

```bash
mint install MakeAWishFoundation/SwiftyMocky
```

3. Check versions:

```bash
mint --version
mint list
/opt/homebrew/bin/sourcery --version
```

## 2. Project Configuration

`Mockfile` in repo root must contain:

```yaml
sourceryCommand: /opt/homebrew/bin/sourcery
sourceryTemplate: ./tools/swiftymocky/Mock.swifttemplate
```

Why template is local: this project uses a patched `Mock.swifttemplate` compatible with modern Swift toolchain.

## 3. Mockable Protocols

File: `TestingTaskTests/ScreenMockables.swift`

Required:

1. Define marker protocol:

```swift
protocol AutoMockable {}
```

2. Every wrapper protocol should inherit from original protocol **and** `AutoMockable`, for example:

```swift
//sourcery: AutoMockable
protocol LoginScreenViewInputMockable: LoginScreenViewInput, AutoMockable {}
```

## 4. Generate Mocks

From project root:

```bash
mint run SwiftyMocky generate
```

Expected successful output:

`✅ Generation done.`

Generated file:

`TestingTaskTests/Support/Generated/Mock.generated.swift`

## 5. Typical Errors and Fixes

### Error: `'characters' is unavailable`

Reason: incompatible template/toolchain combination.

Fix:

1. Use local patched template `./tools/swiftymocky/Mock.swifttemplate`.
2. Ensure `Mockfile` points to this template via `sourceryTemplate`.

### Error: `No mocks generated, haven't found any 'AutoMockable' protocols`

Fix:

1. Ensure wrappers are in `TestingTaskTests/ScreenMockables.swift`.
2. Ensure wrapper protocols inherit `AutoMockable`.
3. Keep `//sourcery: AutoMockable` annotations.

### Error from sandbox/cache access (`ModuleCache`, SwiftPM cache paths)

Fix:

1. Run generation in environment with access to user cache directories.
2. In restricted environments, rerun command with elevated permissions.

## 6. Quick Verification

1. File `TestingTaskTests/Support/Generated/Mock.generated.swift` updated.
2. Contains expected mocks, for example:
   - `LoginScreenViewInputMockableMock`
   - `LoginScreenRouterInputMockableMock`
   - `AuthServiceProtocolMockableMock`
