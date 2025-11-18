# feat: Enhance Auto Responder with UI enhancements & timezone support. Enhance development experience.

## Summary

This PR enhances the Auto Responder feature with comprehensive UI enhancements for multi-pattern triggers, component refactoring for better maintainability, script management capabilities (import/export/delete), enhanced trigger input with real-time parameter feedback, live testing capabilities, timezone support for scripts, and improved development experience. 

## Key Features

🔧 **Component Refactoring**:
- Refactored `AutoResponderSection` into modular directory structure:
  - `src/components/auto-responder/types.ts` - TypeScript interfaces (New)
  - `src/components/auto-responder/utils.ts` - Utility functions (New)
  - `src/components/auto-responder/TriggerItem.tsx` - Individual trigger item component (New)
  - `src/components/auto-responder/PatternExamples.tsx` - Pattern examples and templates component (New)
  - `src/components/auto-responder/ScriptManagement.tsx` - Script management component (New)
- Improved code organization and maintainability

✨ **Timezone Support for Scripts**:
- Scripts now receive `TZ` environment variable for timezone-aware time operations
- Added timezone examples to UI pattern examples and templates section
- Modified `meshtasticManager` to pass `process.env` (including `TZ`) to scripts

🎨 **UI Enhancements**:
- Added timezone examples to pattern examples and templates section
- Enhanced "Time & Date" pattern examples with timezone-aware examples
- Added timezone support tip to Quick Tips section
- Improved layout and visual consistency
- **Script Management** (NEW): Added comprehensive script import/export/delete functionality with modals
  - Import scripts via file upload with validation
  - Export selected or all scripts as ZIP archive
  - Delete scripts with confirmation modal
  - Script management section positioned below pattern examples as collapsible dropdown
  - Copy/download functionality in modals
  - Places scripts in the same directory as the app/container's `/data/scripts/` directory
- **Enhanced Trigger Input** (NEW): Real-time parameter detection and feedback
  - Parameter count display below trigger input
  - Visual highlighting of detected parameters
  - Real-time validation with parameter feedback
  - File type icons in script dropdowns
- **Live Testing** (NEW): Unified live script/HTTP testing
  - Single "🧪 Test" section for all triggers
  - Test scripts and HTTP endpoints directly from trigger creation
  - "🧪 Test" button appears when pattern matches and response type is HTTP/Script
  - Live test results display with copy functionality
  - Enhanced pattern matching results with debug info
  - Parameter highlighting in test results
  - Network error handling with user-friendly messages

### Development Experience
- Added `dotenv` dependency to `package.json` for `.env` file support
- Added `.env` file loading in `server.ts` to ensure environment variables are loaded before `getEnvironmentConfig()` caches the config (fixes issue where `.env` values were ignored if config was cached before dotenv loaded)
- Modified `meshtasticManager` to use lazy-loaded config via `getConfig()` method for fresh `.env` values
- Modified `meshtasticManager` to pass `process.env` (including `TZ`) to scripts for timezone support

📚 **Documentation Updates**:
- Added `TZ` environment variable to Environment Variables table in `docs/developers/auto-responder-scripting.md`
- Added comprehensive Timezone Support section with Python, JavaScript, and Shell examples
- Updated "Deploy to Container" section with three options: UI import, manual deployment, and docker-compose configuration
- Added docker-compose example for scripts requiring environment variables (API keys, timezone, etc.)
- Added timezone examples in UI pattern examples and templates (PatternExamples component)
- Added timezone usage examples in UI Quick Tips section

## Technical Details

### Timezone Support Implementation

**Backend Changes** (`src/server/meshtasticManager.ts`):
- Modified `scriptEnv` to include `process.env`, ensuring `TZ` environment variable is passed to scripts
- Scripts can now access server's configured timezone via `TZ` environment variable

**UI Examples** (in-app documentation):
- Added timezone examples in PatternExamples component (Python, JavaScript, Shell)
- Included IANA timezone name examples (e.g., `America/New_York`) in UI
- Added timezone support tip to Quick Tips section

**UI**:
- Added `time` command button to Common Meshtastic Commands section
- Created new "Time & Date" pattern examples section
- Added timezone support tip to Quick Tips

### Component Refactoring

**New Directory Structure**:
```
src/components/auto-responder/
├── types.ts          # TypeScript interfaces
├── utils.ts          # Utility functions
└── TriggerItem.tsx   # Trigger item component
└── PatternExamples.tsx   # Pattern examples and templates component
└── ScriptManagement.tsx   # Script management component
```

**Utility Functions** (`utils.ts`):
- `splitTriggerPatterns(trigger: string | string[]): string[]` - Splits multi-pattern triggers
- `formatTriggerPatterns(triggerStr: string | string[]): string` - Formats patterns for display
- `getFileIcon(filename: string): string` - Returns emoji icon based on file extension

## Testing

✅ **New Test Suite**:
- Created `tests/unit/auto-responder-utils.test.ts` with 33 comprehensive tests
- Tests cover:
  - `splitTriggerPatterns` with string and array input
  - Edge cases (nested braces, commas inside/outside braces, empty strings)
  - `formatTriggerPatterns` with various input formats
  - `getFileIcon` for different file extensions
- All tests passing ✅

✅ **Existing Tests**:
- All existing auto-responder regex tests still passing
- TypeScript compilation successful
- No linter errors

## Security Considerations

✅ **Security Practices Maintained** (following PR #629 standards):
- Script path validation in backend endpoints (prevents path traversal using `path.basename()`)
- File extension validation for script imports (only `.js`, `.mjs`, `.py`, `.sh` allowed)
- System script protection (prevents overwriting/deleting `upgrade-watchdog.sh`)
- Input validation for trigger patterns (frontend and backend)
- Path traversal prevention in export endpoint (`..` detection)
- No new security vulnerabilities introduced

## Backward Compatibility

✅ **Fully Backward Compatible**:
- All existing triggers continue to work
- No breaking changes to API or data structures
- Existing scripts work without modification
- Timezone support is opt-in (scripts can use `TZ` if needed)

## User Experience

1. **Scripts can now access timezone**: Scripts receive `TZ` environment variable for timezone-aware operations
2. **Better code organization**: Refactored components are easier to maintain and extend
3. **Enhanced UI**: Timezone examples help users understand timezone support

## Example Usage

### Timezone-Aware Script (Python)
```python
#!/usr/bin/env python3
import os
from datetime import datetime

tz = os.environ.get('TZ', 'UTC')
print(f"Current time in {tz}: {datetime.now().strftime('%Y-%m-%d %H:%M:%S %Z')}")
```

### Multi-Pattern Trigger with Array Format
```typescript
// Now properly handles both formats:
trigger: "time"  // String format
trigger: ["time", "date"]  // Array format
```

## Dependencies

- Added `dotenv` (^17.2.3) for `.env` file loading in development mode
- Uses existing Node.js `process.env` for timezone support

## Related PRs

- Builds upon PR #628 (Multi-Pattern Triggers)
- Follows security practices from PR #629 (User Scripts Gallery)

## Checklist

- [x] All tests passing
- [x] TypeScript compilation successful
- [x] No linter errors
- [x] Documentation updated
- [x] Backward compatible
- [x] Security practices maintained
- [x] Code refactored for maintainability
- [x] Bug fixes verified

