//
//  Localization.swift
//  PMCoreTranslation
//
//  Created by Greg on 07.11.20.
//

import Foundation

public var CoreString = LocalizedString()

public class LocalizedString {

    // Human verification

    /// Title
    public lazy var _hv_title = NSLocalizedString("Human verification", bundle: Common.bundle, comment: "Title")
    
    /// Captcha method name
    public lazy var _hv_captha_method_name = NSLocalizedString("CAPTCHA", bundle: Common.bundle, comment: "captha method name")
    
    /// sms method name
    public lazy var _hv_sms_method_name = NSLocalizedString("SMS", bundle: Common.bundle, comment: "SMS method name")
    
    /// email method name
    public lazy var _hv_email_method_name = NSLocalizedString("Email", bundle: Common.bundle, comment: "email method name")
    
    /// Help button
    public lazy var _hv_help_button = NSLocalizedString("Help",  bundle: Common.bundle, comment: "Help button")
    
    /// OK button
    public lazy var _hv_ok_button = NSLocalizedString("OK",  bundle: Common.bundle, comment: "OK button")
    
    /// Cancel button
    public lazy var _hv_cancel_button = NSLocalizedString("Cancel",  bundle: Common.bundle, comment: "Cancel button")
    
    // Human verification - email method
    
    /// Email enter label
    public lazy var _hv_email_enter_label = NSLocalizedString("Your email will only be used for this one-time verification.",  bundle: Common.bundle, comment: "Enter email label")
    
    /// Email  label
    public lazy var _hv_email_label = NSLocalizedString("Email",  bundle: Common.bundle, comment: "Email label")
    
    /// Email  verification button
    public lazy var _hv_email_verification_button = NSLocalizedString("Get verification code",  bundle: Common.bundle, comment: "Verification button")
    
    /// Email  have code button
    public lazy var _hv_email_have_code_button = NSLocalizedString("I already have a code",  bundle: Common.bundle, comment: "Habe code button")

    // Human verification - sms method
    
    /// SMS enter label
    public lazy var _hv_sms_enter_label = NSLocalizedString("Your phone number will only be used for this one-time verification.",  bundle: Common.bundle, comment: "Enter SMS label")
    
    /// SMS  label
    public lazy var _hv_sms_label = NSLocalizedString("Phone number",  bundle: Common.bundle, comment: "SMS label")
    
    /// Search country placeholder
    public lazy var _hv_sms_search_placeholder = NSLocalizedString("Search country",  bundle: Common.bundle, comment: "Search country placeholder")
    
    // Human verification - verification
    
    /// Verification enter sms code label
    public lazy var _hv_verification_enter_sms_code = NSLocalizedString("Enter the verification code that was sent to %@",  bundle: Common.bundle, comment: "Enter sms code label")
    
    /// Verification enter email code label
    public lazy var _hv_verification_enter_email_code = NSLocalizedString("Enter the verification code that was sent to %@. If you don't find the email in your inbox, please check your spam folder.",  bundle: Common.bundle, comment: "Enter email code label")
    
    /// Verification code label
    public lazy var _hv_verification_code = NSLocalizedString("Verification code",  bundle: Common.bundle, comment: "Verification code label")
    
    /// Verification code hint label
    public lazy var _hv_verification_code_hint = NSLocalizedString("Enter the 6-digit code.",  bundle: Common.bundle, comment: "Verification code hint label")
    
    /// Verification code Verify button
    public lazy var _hv_verification_verify_button = NSLocalizedString("Verify",  bundle: Common.bundle, comment: "Verify button")
    
    /// Verification code Verifying button
    public lazy var _hv_verification_verifying_button = NSLocalizedString("Verifying",  bundle: Common.bundle, comment: "Verifying button")
    
    public lazy var _hv_verification_not_receive_code_button = NSLocalizedString("Did not receive the code?",  bundle: Common.bundle, comment: "Not receive code button")

    /// Verification code error alert title
    public lazy var _hv_verification_error_alert_title = NSLocalizedString("Invalid verification code",  bundle: Common.bundle, comment: "alert title")
    
    /// Verification code error alert message
    public lazy var _hv_verification_error_alert_message = NSLocalizedString("Would you like to receive a new verification code or use an alternative verification method?",  bundle: Common.bundle, comment: "alert message")
    
    /// Verification code error alert resend button
    public lazy var _hv_verification_error_alert_resend = NSLocalizedString("Resend",  bundle: Common.bundle, comment: "resend alert button")
 
    /// Verification code error alert try other method button
    public lazy var _hv_verification_error_alert_other_method = NSLocalizedString("Try other method",  bundle: Common.bundle, comment: "other method alert button")
    
    /// Verification new code alert title
    public lazy var _hv_verification_new_alert_title = NSLocalizedString("Request new code?",  bundle: Common.bundle, comment: "alert title")
    
    /// Verification new code alert message
    public lazy var _hv_verification_new_alert_message = NSLocalizedString("Get a replacement code sent to %@.",  bundle: Common.bundle, comment: "alert message")
    
    /// Verification new code alert new code button
    public lazy var _hv_verification_new_alert_button = NSLocalizedString("Request new code",  bundle: Common.bundle, comment: "new code alert button")
    
    /// Verification new code sent banner title
    public lazy var _hv_verification_sent_banner = NSLocalizedString("Code sent to %@",  bundle: Common.bundle, comment: "sent baner title")
    
    // Human verification - help
    
    /// Verification help header title
    public lazy var _hv_help_header = NSLocalizedString("Need help with human verification?",  bundle: Common.bundle, comment: "help header title")
    
    /// Verification help request item title
    public lazy var _hv_help_request_item_title = NSLocalizedString("Request an invite",  bundle: Common.bundle, comment: "request item title")
    
    /// Verification help request item message
    public lazy var _hv_help_request_item_message = NSLocalizedString("If you are having trouble creating your account, please request an invitation and we will respond within 1 business day.",  bundle: Common.bundle, comment: "request item message")
    
    /// Verification help visit item title
    public lazy var _hv_help_visit_item_title = NSLocalizedString("Visit our Help Center",  bundle: Common.bundle, comment: "visit item title")
    
    /// Verification help visit item message
    public lazy var _hv_help_visit_item_message = NSLocalizedString("Learn more about human verification and why we ask for it.",  bundle: Common.bundle, comment: "visit item message")
    
    // Force upgrade
    
    /// Force upgrade alert title
    public lazy var _fu_alert_title = NSLocalizedString("Update required",  bundle: Common.bundle, comment: "alert title")
    
    /// Force upgrade alert leran more button
    public lazy var _fu_alert_learn_more_button = NSLocalizedString("Learn more",  bundle: Common.bundle, comment: "learn more button")
    
    /// Force upgrade alert update button
    public lazy var _fu_alert_update_button = NSLocalizedString("Update",  bundle: Common.bundle, comment: "update button")
    
    /// Force upgrade alert quit button
    public lazy var _fu_alert_quit_button = NSLocalizedString("Quit",  bundle: Common.bundle, comment: "quit button")
    
}
