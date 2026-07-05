# React Native

Loaded alongside `react-core.md` (language-level React still applies). This module is native-specific. No DOM — flag any web-only assumption.

> If `legend-state.md` is loaded, its **native section** activates: prefer Legend's reactive RN components (`$View`, `$TextInput`, `$value`) over the plain-RN + `observer` patterns. Defer list/memoization findings there.

## Lists

- **`FlatList`/`SectionList`** for long/dynamic lists — flag `.map()` rendering large arrays inside a `ScrollView` (renders everything, no recycling).
- Stable `keyExtractor`, not index.
- `getItemLayout` for fixed-height rows; `windowSize`/`maxToRenderPerBatch` tuned for heavy lists.

## Rendering & performance

- Heavy list rows wrapped in `React.memo` (or rendered via Legend's reactive components).
- No inline functions/objects created in render and passed to memoized children.
- `InteractionManager`/deferred work for post-animation tasks.
- Images sized explicitly; consider `expo-image`/`FastImage` for caching.

## Platform & navigation

- `Platform.select` / `.ios.tsx` / `.android.tsx` for platform divergence, not runtime `if (Platform.OS)` scattered everywhere.
- Navigation (React Navigation/Expo Router) screens lazy where possible; params typed.
- Safe-area handled via `SafeAreaView`/insets, not hardcoded padding.

## Native correctness

- Touchables have `hitSlop` and accessible roles/labels.
- `AsyncStorage` (or MMKV) access centralized — flag scattered raw calls (and prefer Legend persistence if `legend-state.md` is loaded).
- Lists/screens avoid anonymous styles — `StyleSheet.create` over inline objects.
