# Player State Persists Between Accounts: Unauthorized Songs Remain Playable After Account Switch

## Issue #119

### Steps to Reproduce
1. Log into Account A
2. Play any song from a bundle
3. Log out of Account A
4. Log into Account B (that doesn't own the bundle)
5. Notice: The same song continues playing
6. Notice: Can continue playing songs from Account A's bundle until selecting a different song

### Expected Behavior
- Player should reset when switching accounts
- Songs from previous account's bundle should not be playable

### Actual Behavior
- Previous account's song continues playing
- Can access songs from previous account's bundle until selecting a new song

### Environment
- Beta 237 (1.22.0)
- Reproducible on both Android and iOS

### Technical Note
Issue appears to be related to `playerBloc` not properly resetting to its initial state during account switching, causing the conditional check `playerBloc.state.status == PlayerStatus.initial` to fail.
