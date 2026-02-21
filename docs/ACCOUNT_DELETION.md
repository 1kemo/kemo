# Account Deletion Feature - App Store Compliance

## Overview
This app now includes account deletion functionality to comply with Apple App Store Guideline 5.1.1(v) - Data Collection and Storage.

## Implementation Details

### Location
The account deletion feature is accessible from the Profile Screen (`lib/screens/profile_screen.dart`).

### User Flow
1. User opens the app and navigates to the Profile tab
2. Scrolls down to find the "删除账号" (Delete Account) option
3. Taps on "删除账号"
4. A confirmation dialog appears with:
   - Clear warning about permanent deletion
   - List of all data that will be deleted:
     - All mood records
     - All chat history
     - Personal settings and preferences
     - Achievements and statistics
   - Warning that the action cannot be undone
   - Cancel and Confirm buttons

5. Upon confirmation:
   - All local data is permanently deleted
   - User is logged out
   - User is returned to the login screen
   - A confirmation message is displayed

### What Gets Deleted
When a user deletes their account, the following data is permanently removed:
- Login status
- All mood records
- All chat history (conversations with AI)
- Selected AI personality preferences
- Daily quotes
- Notification settings
- AI data sharing consent
- All other app preferences stored in SharedPreferences

### Technical Implementation
- Uses `StorageService.clearAllData()` to remove all data from SharedPreferences
- Navigates user back to LoginScreen with `pushAndRemoveUntil` to clear navigation stack
- No server-side deletion needed as this app stores all data locally

### Compliance Notes
- ✅ Account deletion is easily accessible from the Profile screen
- ✅ Clear confirmation dialog prevents accidental deletion
- ✅ All user data is permanently deleted
- ✅ User is logged out and returned to login screen
- ✅ No customer service contact required (app is not in highly-regulated industry)
- ✅ Process is completed entirely within the app

## App Review Response Template

When responding to App Review in App Store Connect, you can use:

---

**Subject: Account Deletion Feature Implementation**

Dear App Review Team,

We have implemented account deletion functionality in our app to comply with Guideline 5.1.1(v).

**How to access account deletion:**
1. Open the app and log in
2. Navigate to the "精神轨道" (Profile) tab at the bottom
3. Scroll down to the bottom of the profile screen
4. Tap on "删除账号" (Delete Account)
5. Confirm the deletion in the dialog that appears

The account deletion feature:
- Permanently deletes all user data including mood records, chat history, and preferences
- Logs the user out and returns them to the login screen
- Includes a confirmation step to prevent accidental deletion
- Completes the entire process within the app without requiring external contact

All user data is stored locally on the device, and the deletion process removes all data from the device's local storage.

Thank you for your review.

---

## Testing
To test the account deletion feature:
1. Create an account and add some data (mood records, chat messages)
2. Go to Profile screen
3. Scroll to bottom and tap "删除账号"
4. Verify the confirmation dialog appears with appropriate warnings
5. Confirm deletion
6. Verify you're returned to login screen
7. Log in again and verify all previous data is gone
