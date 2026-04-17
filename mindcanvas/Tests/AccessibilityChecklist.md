# Accessibility Testing Checklist for MindCanvas (SwiftUI)

- [ ] All interactive elements have accessibility labels (e.g., .accessibilityLabel("Save"))
- [ ] All images/icons have descriptive labels or are marked as decorative
- [ ] Dynamic Type is supported (text scales with system settings)
- [ ] Sufficient color contrast for text and UI elements
- [ ] Large tap areas for all buttons and controls
- [ ] VoiceOver navigation is logical and complete
- [ ] Reduced motion is supported (animations respect system settings)
- [ ] All forms and fields have clear labels and error feedback
- [ ] Accessibility Inspector in Xcode passes for all screens
- [ ] Accessibility traits are set (e.g., .accessibilityAddTraits(.isButton))
- [ ] Test with VoiceOver enabled on device/simulator

## How to Use
1. Open Xcode > Product > Run on Simulator or Device
2. Enable VoiceOver (Cmd+F5 on Mac, Settings > Accessibility on iOS)
3. Use Xcode’s Accessibility Inspector (Xcode > Open Developer Tool > Accessibility Inspector)
4. Walk through all flows: onboarding, mood check-in, memory creation, etc.
5. Check off each item above for every screen.
