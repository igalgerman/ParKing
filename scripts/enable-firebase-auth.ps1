# Firebase Authentication Setup Script
# Opens Firebase Console to enable authentication providers

$projectId = "parking-poc-39dbb"
$authProvidersUrl = "https://console.firebase.google.com/project/$projectId/authentication/providers"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Firebase Authentication Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Project: $projectId" -ForegroundColor Yellow
Write-Host ""
Write-Host "Opening Firebase Console..." -ForegroundColor Green
Write-Host ""
Write-Host "Please enable the following providers:" -ForegroundColor White
Write-Host ""
Write-Host "  1. ✅ Email/Password (already enabled)" -ForegroundColor Green
Write-Host "  2. 🔵 Google Sign-In" -ForegroundColor Cyan
Write-Host "  3. 📱 Phone Authentication" -ForegroundColor Cyan
Write-Host "  4. 🍎 Apple Sign-In (optional - iOS only)" -ForegroundColor Cyan
Write-Host ""
Write-Host "For each provider:" -ForegroundColor Yellow
Write-Host "  - Click the provider name" -ForegroundColor White
Write-Host "  - Click 'Enable' toggle" -ForegroundColor White
Write-Host "  - Click 'Save'" -ForegroundColor White
Write-Host ""

# Open browser
Start-Process $authProvidersUrl

Write-Host "Browser opened! Enable the providers above." -ForegroundColor Green
Write-Host ""
Write-Host "After enabling, run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Wait for user confirmation
Write-Host ""
Read-Host "Press Enter when you've enabled the providers"

Write-Host ""
Write-Host "✅ Setup complete! You can now test authentication." -ForegroundColor Green
Write-Host ""
