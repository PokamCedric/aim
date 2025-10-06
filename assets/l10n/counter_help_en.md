# Counter Demo Help

## Overview

The Counter Demo page is a simple demonstration of how to use the AbstractPageState framework to create interactive pages with state management.

## Features

### Counter Display
- Shows the current counter value in large text
- Displays "time" (singular) or "times" (plural) based on the count
- Visual feedback with card styling and shadows

### Action Buttons

#### Increment Button (Floating)
- Located at the bottom of the screen (or right side on wide screens)
- Adds 1 to the counter each time you press it
- Always available, no matter what the counter value is

#### Decrease Button
- Reduces the counter by 1
- **Disabled when counter is at 0** (can't go negative)
- Red/error color scheme to indicate it's a destructive action

#### Reset Button
- Sets the counter back to 0
- **Disabled when counter is already at 0**
- Secondary color scheme

### Zoom Control

Adjust the page zoom level to make content larger or smaller:

- **Slider**: Drag to adjust zoom from 60% to 200%
- **Current Level**: Displayed as percentage above the slider
- **Reset Button**: Quickly return to 100% zoom
- **Range**: 60% (minimum) to 200% (maximum)

The zoom affects the entire page content, making it accessible for different viewing preferences.

### Statistics Card

Dynamic messages based on your progress:
- **0 clicks**: "Start counting by pressing the button below!"
- **1-9 clicks**: "Keep going, you're doing great!"
- **10-49 clicks**: "Wow! You're on a roll!"
- **50+ clicks**: "Amazing! You've reached [number]!"

## Tips & Tricks

1. **Quick Reset**: Use the reset icon in the top app bar (appears when counter > 0)
2. **Keyboard Navigation**: The page supports keyboard navigation on desktop
3. **Accessibility**: All buttons have tooltips and semantic labels for screen readers
4. **Responsive**: The layout adapts automatically to different screen sizes
5. **Zoom Persistence**: Your zoom preference is saved and restored when you return

## How It Works

This page demonstrates several key concepts:

### State Management
- Uses `setState()` to update the UI when values change
- Counter value is maintained in the page state
- Zoom level is managed through Provider (AppZoom)

### Conditional UI
- Buttons are disabled when actions aren't valid
- Reset button in app bar only appears when needed
- Empty state vs. active state in statistics

### Responsive Design
- Containers adapt width based on screen size
- Text and spacing scale with zoom level
- Scrollable content prevents overflow at high zoom

### Material Design 3
- Uses proper color roles (primary, secondary, error, tertiary)
- Follows accessibility guidelines for contrast
- Implements modern visual hierarchy

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Increment | Floating button or Enter |
| Reset | App bar reset icon |
| Navigate | Tab / Shift+Tab |

## Troubleshooting

**Counter won't decrease below 0**
- This is by design to prevent negative values

**Content is cut off at high zoom**
- Scroll down to see all content
- The page becomes scrollable automatically

**Reset button missing**
- It only appears when counter > 0
- Check the top app bar on the right side

**Zoom not persisting**
- Ensure SharedPreferences is properly initialized
- Check that AppZoom provider is in the widget tree

## Technical Details

- **Framework**: Flutter with AbstractPageState
- **State Management**: Provider + Local State
- **Persistence**: SharedPreferences (for zoom)
- **Responsive**: LayoutBuilder + MediaQuery
- **Accessibility**: Semantic labels + tooltips
