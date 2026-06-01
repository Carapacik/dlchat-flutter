enum Routes(final String path) {
  /// initial
  splash('/'),
  onboarding('/onboarding'),

  /// auth
  signIn('/sign-in'),
  otpCode('otp-code'),

  /// mains
  main('/main'),
  home('/home'),
  settings('/settings'),
  faq('/faq'),
  faqNested('/faq'),

  /// chats
  chats('/chats'),
  chat('/chat/:id'),
  chatNested('/chat/:id'),
  rates('/rates'),
  ratesNested('/rates'),

  /// payments
  bingingCards('/binding-cards'),
  bingingCardsNested('/binding-cards'),
  paymentWebView('/payment-web-view'),
  paymentWebViewNested('/payment-web-view'),
  paymentResult('/payment/result/:result'),
  paymentResultNested('/payment/result/:result'),

  /// voice chat
  transcriptionsOnboarding('/transcriptions-onboarding'),
  transcriptionsOnboardingNested('/transcriptions-onboarding'),
  transcriptions('/transcriptions'),
  transcriptionsNested('/transcriptions'),
  detailTranscription('/transcription/:id'),
  detailTranscriptionNested(':id'),

  /// Nutritionist
  nutritionistOnboarding('/nutritionist-onboarding'),
  nutritionistOnboardingNested('/nutritionist-onboarding'),
  nutritionistFillingData('/nutritionist-filling-data'),
  nutritionistFillingDataNested('/nutritionist-filling-data'),

  /// System screen
  connectionError('/connection-error'),
  technicalError('/technical-error'),
  updateApp('/update-app'),
}
