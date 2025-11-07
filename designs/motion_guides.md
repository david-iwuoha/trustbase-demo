TrustBase Motion & Animation Guidelines
Core Principles
Smooth & Natural: All animations should feel fluid and purposeful
Telegram-inspired: Use similar easing and timing to Telegram’s polished feel
Performance-first: Optimize for 60fps on mobile devices
Easing Curves
Standard: cubic-bezier(0.4, 0.0, 0.2, 1) - General purpose
Decelerate: cubic-bezier(0.0, 0.0, 0.2, 1) - Elements entering screen
Accelerate: cubic-bezier(0.4, 0.0, 1, 1) - Elements leaving screen
Sharp: cubic-bezier(0.4, 0.0, 0.6, 1) - Quick transitions
Timing Guidelines
Screen Transitions
Page Navigation: 300ms with decelerate easing
Modal Entry: 250ms with decelerate easing
Modal Exit: 200ms with accelerate easing
Splash to Login: 400ms crossfade
Micro-interactions
Button Press: 150ms scale (0.95) with sharp easing
Card Hover: 200ms elevation change
Input Focus: 200ms border color transition
Toggle Switch: 150ms with standard easing
Loading States
Shimmer Animation: 1.5s loop with linear easing
Spinner: 1s rotation with linear easing
Progress Bar: 300ms width change with decelerate easing
Specific Animations
Splash Screen
Logo fade-in: 600ms with decelerate easing
Logo scale: subtle 1.0 to 1.05 over 800ms
Transition to login: 400ms slide-up with crossfade
Login Screen
Card entrance: 300ms slide-up from bottom with decelerate
Field focus: 200ms scale (1.02) and border color change
Button press: 150ms scale (0.98) with haptic feedback
Dashboard
Cards stagger entrance: 100ms delay between each card
Pull-to-refresh: elastic bounce with 400ms duration
Profile popup: 250ms scale from 0.8 to 1.0 with backdrop fade
Glassmorphism Effects
Glass card hover: 200ms backdrop-filter blur increase
Glass surface press: 150ms opacity change (0.25 to 0.35)
Implementation Notes
Use Flutter’s built-in animation controllers
Implement haptic feedback for button presses
Ensure animations respect system accessibility settings
Test on lower-end devices for performance
