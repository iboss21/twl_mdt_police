# UI Assets Guide

This directory contains the user interface assets for LEO-CORE.

## Directory Structure

```
ui/
├── badges/         # Agency badge images
├── styles/         # CSS stylesheets
├── index.html      # Main UI interface
├── script.js       # UI JavaScript logic
├── vue.min.js      # Vue.js framework
├── main.css        # Main stylesheet
├── bg.jpg          # Background image
└── mugshot.png     # Default mugshot placeholder
```

## Badge Images

Badge images should be placed in the `badges/` directory:

### Required Badges
- `sheriff.png` - Sheriff's Department badge
- `police.png` - Police Department badge (already exists)
- `marshal.png` - U.S. Marshal Service badge
- `ranger.png` - Park Rangers badge
- `army.png` - U.S. Army badge (optional)

### Badge Specifications
- **Format**: PNG with transparency
- **Recommended Size**: 512x512 pixels
- **Max Size**: 1024x1024 pixels
- **File Size**: Keep under 500KB each
- **Background**: Transparent (alpha channel)

### Finding Badge Images

You can:
1. Create custom badges using image editing software
2. Commission a designer
3. Use historical badge designs (public domain)
4. Search for royalty-free badge graphics

**Note**: Respect copyright and licensing when using badge images.

## Custom Background

Replace `bg.jpg` with your own background:
- **Format**: JPEG or PNG
- **Recommended Size**: 1920x1080 or larger
- **Theme**: Dark/neutral colors work best
- **File Size**: Optimize for web (under 2MB)

## Mugshot Placeholder

`mugshot.png` is the default image shown when no mugshot is available:
- **Format**: PNG with transparency
- **Size**: 400x400 pixels recommended
- **Content**: Generic silhouette or placeholder icon

## Stylesheets

### Main Styles
- `main.css` - Core UI styles
- `styles/police.css` - Agency-specific styles

### Customization
You can modify these to match your server's theme:
- Colors
- Fonts
- Layout
- Animations

### CSS Variables
Consider using CSS variables for easy theme switching:
```css
:root {
    --primary-color: #1E3A8A;
    --secondary-color: #8B4513;
    --text-color: #FFFFFF;
    --bg-color: #0F172A;
}
```

## JavaScript Files

### script.js
Contains the UI logic for:
- MDT interactions
- Form handling
- Data display
- NUI callbacks

### vue.min.js
Vue.js framework for reactive UI components.

**Warning**: Don't modify `vue.min.js` unless you know what you're doing.

## HTML Interface

`index.html` is the main MDT interface:
- Built with HTML5
- Uses Vue.js for reactivity
- Communicates with FiveM via NUI

### Modifying the Interface
1. Edit `index.html` for structure changes
2. Update `script.js` for logic changes
3. Modify CSS files for styling changes
4. Test thoroughly before deploying

## NUI Communication

The UI communicates with the game using NUI messages:

### From Game to UI
```javascript
window.addEventListener('message', function(event) {
    if (event.data.type === 'openMDT') {
        // Handle MDT opening
    }
});
```

### From UI to Game
```javascript
$.post('https://leo-core/callback', JSON.stringify({
    action: 'getData',
    data: someData
}));
```

## Adding New UI Features

To add a new MDT module:
1. Add HTML section in `index.html`
2. Add styles in `main.css` or new CSS file
3. Add JavaScript logic in `script.js`
4. Add server-side handlers in `server_leo.lua`
5. Add client-side callbacks in `client_leo.lua`

## Testing UI Changes

1. Edit files in this directory
2. Restart the resource: `restart leo-core`
3. Open MDT in-game: `/mdt`
4. Check browser console (F12) for errors
5. Test all functionality

## Performance Tips

- Optimize images (use compression tools)
- Minimize HTTP requests
- Use CSS instead of images where possible
- Lazy load large datasets
- Cache static assets
- Minimize JavaScript

## Responsive Design

The MDT should work at different resolutions:
- 1920x1080 (recommended)
- 1680x1050
- 1600x900
- 1366x768 (minimum)

Test at multiple resolutions to ensure usability.

## Dark Mode

LEO-CORE uses dark mode by default (as stated in PRD: "Dark mode mandatory - lawmen work at night").

Ensure all UI elements:
- Have good contrast
- Are readable in dark theme
- Don't cause eye strain

## Accessibility

Consider accessibility:
- Sufficient color contrast
- Readable font sizes (minimum 14px)
- Keyboard navigation support
- Screen reader compatibility
- Clear focus indicators

## Browser Compatibility

The CEF (Chromium Embedded Framework) in FiveM uses Chromium.

Test with:
- Modern CSS features
- ES6 JavaScript
- Flexbox/Grid layouts
- Custom fonts

Avoid:
- Internet Explorer specific code
- Very new experimental features
- External dependencies (load locally)

## File Sizes

Keep assets optimized:
- Images: < 500KB each
- CSS: < 100KB total
- JavaScript: < 500KB total
- Total UI: < 10MB

## Security Notes

- Sanitize all user input
- Don't trust client-side data
- Validate on server-side
- Use CSP headers if possible
- Avoid inline JavaScript

## Troubleshooting

### UI not loading
- Check `fxmanifest.lua` includes files
- Verify file paths are correct
- Check browser console (F12)
- Restart resource

### Images not showing
- Check file names match exactly (case-sensitive)
- Verify files exist in correct directory
- Check `fxmanifest.lua` lists files
- Clear browser cache

### JavaScript errors
- Open browser console (F12)
- Check error messages
- Verify syntax
- Test in Chrome DevTools

### Styling issues
- Check CSS syntax
- Verify selectors are correct
- Inspect element (F12)
- Check CSS specificity

## Resources

- Vue.js Documentation: https://vuejs.org/
- MDN Web Docs: https://developer.mozilla.org/
- FiveM NUI Guide: https://docs.fivem.net/docs/scripting-reference/nui/
- Chromium CSS Support: https://chromestatus.com/

## Getting Help

If you need help with UI customization:
1. Check the browser console for errors
2. Review Vue.js documentation
3. Check FiveM NUI documentation
4. Ask in community forums
5. Create a GitHub issue

---

**Remember**: Always backup files before making changes!
