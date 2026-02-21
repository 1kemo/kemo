# App Store Review Response - Guideline 5.1.1(v) Account Deletion

## Response to App Review Team

Dear App Review Team,

Thank you for your feedback regarding Guideline 5.1.1(v) - Data Collection and Storage. We have implemented account deletion functionality in our app.

---

## How to Locate the Account Deletion Feature

### Step-by-Step Instructions:

1. **Launch the app** and complete the login process
2. **Navigate to the Profile tab** (精神轨道) - it's the rightmost icon in the bottom navigation bar
3. **Scroll down** to the bottom of the profile screen
4. **Locate "删除账号" (Delete Account)** - it's the last menu item with a person icon (Icons.person_remove_outlined)
5. **Tap on "删除账号"** to initiate the account deletion process
6. **Review the confirmation dialog** which clearly explains:
   - What data will be deleted (mood records, chat history, settings, achievements)
   - That the action is permanent and cannot be undone
   - That the user will need to create a new account to use the app again
7. **Tap "确认删除" (Confirm Delete)** to complete the deletion

### What Happens After Deletion:
- All user data is permanently removed from local storage
- User is automatically logged out
- User is returned to the login screen
- A confirmation message appears: "账号已删除" (Account Deleted)

---

## Implementation Details

### Compliance with Guidelines:
✅ **Easy Access**: Feature is accessible directly from the Profile screen, no external website required  
✅ **Clear Process**: Single-step deletion within the app  
✅ **Confirmation Step**: Includes a detailed confirmation dialog to prevent accidental deletion  
✅ **Complete Deletion**: All user data is permanently removed  
✅ **No Customer Service Required**: Entire process is self-service within the app  

### Data Deleted:
When a user deletes their account, the following data is permanently removed:
- Login status and authentication state
- All mood records (情绪记录)
- All chat history with AI
- Selected AI personality preferences
- Daily quotes and notifications settings
- AI data sharing consent
- All app preferences and settings

### Technical Implementation:
- Location: `lib/screens/profile_screen.dart` - `_deleteAccount()` method
- Uses `StorageService.clearAllData()` to remove all SharedPreferences data
- Navigates to LoginScreen with `pushAndRemoveUntil` to clear navigation stack
- All data is stored locally; no server-side deletion required

---

## Visual Location

```
Profile Screen (精神轨道)
│
├── Statistics Cards (统计卡片)
├── Recent Records (最近记录)
├── Achievements (成就勋章)
│
└── Menu Items:
    ├── 金币商店 (Coin Shop)
    ├── 情绪统计 (Mood Statistics)
    ├── 历史记录 (History)
    ├── 导出数据 (Export Data)
    ├── 退出登录 (Logout)
    ├── 清除数据 (Clear Data)
    └── 删除账号 (Delete Account) ← HERE
```

---

## Difference from "Clear Data"

We provide two separate options to give users flexibility:

**清除数据 (Clear Data)**:
- Deletes all data but keeps user logged in
- User remains on Profile screen
- For users who want a fresh start while keeping their account

**删除账号 (Delete Account)**:
- Deletes all data AND logs user out
- Returns to login screen
- Indicates complete account deletion
- Meets App Store requirement for account deletion

---

## Testing Instructions

To verify the feature:
1. Create a test account and add some data (mood records, chat messages)
2. Navigate to Profile → 删除账号
3. Observe the detailed confirmation dialog
4. Confirm deletion
5. Verify automatic logout and return to login screen
6. Log in again and verify all data is gone

---

## Additional Notes

- This app stores all data locally on the device (no cloud backend)
- No personally identifiable information is collected
- The app is not in a highly-regulated industry
- No external customer service contact is required for account deletion
- The entire deletion process is completed within the app

We believe this implementation fully complies with Guideline 5.1.1(v) and provides users with clear, easy access to account deletion.

Thank you for your consideration.

---

**App Name**: 心动信号 (PulseMind AI)  
**Version**: 0.1.0  
**Implementation Date**: February 21, 2026
