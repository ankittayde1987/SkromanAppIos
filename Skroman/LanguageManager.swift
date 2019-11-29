
//
//  LanguageManager.swift
//  getAMe
//
//  Created by admin on 6/10/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

let kUserPreferedLanguageKey:String = "userPreferedLanguage"
let kUserPreferedLocaleKey:String = "userPreferedLocale"

let LANGUAGE_ENGLISH_CODE:String = "en"
let LANGUAGE_ENGLISH_LOCALE_CODE:String = "en_US"

let LANGUAGE_SPANISH_CODE:String = "es"
let LANGUAGE_SPANISH_LOCALE_CODE:String = "es"


class LanguageManager: NSObject {
    
    enum LanguageManagerLanguage : Int {
        case English = 0
        case Spanish
    }
    
    var bundle: Bundle!
    var supportedLanguages: NSArray!
    
    class func get(key: String, alter alternate: String) -> String {
        return LanguageManager.sharedInstance().get(key: key, alter: alternate)
    }
    
    class func getPerferedLanguageInInteger() -> LanguageManagerLanguage {
        return LanguageManager.sharedInstance().getPerferedLanguageInInteger()
    }
    
    class func nativeLanguageNameForLocale(isoIdentifier: String) -> String {
        return LanguageManager.sharedInstance().nativeLanguageName(forLocale: isoIdentifier)
    }
    
    class func getPerferedLocaleCode() -> String {
        return LanguageManager.sharedInstance().getPerferedLocaleCode()
    }
    
    class func getPerferedLocale() -> NSLocale {
        return LanguageManager.sharedInstance().getPerferedLocale()
    }
    
    class func getPerferedLanguage() -> String {
        return LanguageManager.sharedInstance().getPerferedLanguage()
    }
    
    class func getPerferedLanguageForServer() -> String {
        return LanguageManager.sharedInstance().getPerferedLanguageForServer()
    }
    
    class func getPluralizedString(key: String, withNumber n: CGFloat, alter alternate: String) -> String {
        return LanguageManager.sharedInstance().getPluralizedString(key: key, withNumber: n, alter: alternate)
    }
    
    class func getLocalizeCountryNameWithCode(countryCode: String) -> String {
        return LanguageManager.sharedInstance().getLocalizeCountryNameWithCode(countryCode: countryCode)
    }
    
    class func getLocalizeCurrencyNameWithCode(currencyCode: String) -> String {
        return LanguageManager.sharedInstance().getLocalizeCurrencyNameWithCode(currencyCode: currencyCode) as String
    }
    
    class func getLocalizedImage(imageName: String) -> UIImage {
        return LanguageManager.sharedInstance().getLocalizedImage(imageName: imageName)
    }
    
    class func getCurrentLocale() -> NSLocale {
        return LanguageManager.sharedInstance().getCurrentLocale()
    }
    
    class func setUserPerferedLanguage(language: String, withLocale locale: String) {
        return LanguageManager.sharedInstance().setUserPerferedLanguage(language: language, withLocale: locale)
    }
    
    class func setLanguageWithIntType(language_value: LanguageManagerLanguage) {
        return LanguageManager.sharedInstance().setLanguageWithIntType(language_value: language_value)
    }
    
    class func setLanguageAsEnglish() {
        return LanguageManager.sharedInstance().setLanguageAsEnglish()
    }
    
    
    class func sharedInstance() -> LanguageManager {
        
         var sharedInstance: LanguageManager {
            struct Static {
                static let instance = LanguageManager()
            }
            return Static.instance
        }
        return sharedInstance
    }
    
    override init() {
        super.init()
        
        self.supportedLanguages = [LANGUAGE_ENGLISH_CODE, LANGUAGE_SPANISH_CODE]

        setUserPerferedLanguage(language: getPerferedLanguage(), withLocale: getPerferedLocaleCode())
        
    }
    
    func get(key: String, alter alternate: String) -> String {
        return bundle.localizedString(forKey: key, value: alternate, table: nil)
    }
    
    func getPluralizedString(key: String, withNumber n: CGFloat, alter alternate: String) -> String {
        /*return [_bundle pluralizedStringWithKey:key
        defaultValue:@""
        table:@""
        pluralValue:n
        forLocalization:[LanguageManager getPerferedLanguage]];*/
        return ""
    }
    
    func setUserPerferedLanguage(language: String?, withLocale locale: String) {
        if language == nil || language == "" {
            self.setDefaultLanguage()
        }
        else {
            self.setLanguageInUserDefaultsWithLangaueCode(language: language!, withLocaleCode: locale)
        }
    }
    
    func setLanguageWithIntType(language_value: LanguageManagerLanguage) {
        switch language_value
        {
        case .English:
            LanguageManager.setLanguageAsEnglish()
        case .Spanish:
            LanguageManager.setLanguageAsSpanish()
       
        }
        
    }
    
    func setLanguageInUserDefaultsWithLangaueCode(language: String, withLocaleCode locale: String) {
        let defaults: UserDefaults = UserDefaults.standard
        /*  NSArray* languages = [NSArray arrayWithObject:language];
        [[NSUserDefaults standardUserDefaults] setObject:languages
        forKey:@"AppleLanguages"];*/
        defaults.set(language, forKey: kUserPreferedLanguageKey)
         defaults.set(locale, forKey: kUserPreferedLocaleKey)

//        defaults[kUserPreferedLanguageKey] = language
//        defaults[kUserPreferedLocaleKey] = locale
        defaults.synchronize()
        let path: String = Bundle.main.path(forResource: language, ofType: "lproj")!
        self.bundle = Bundle(path: path)
    }
    
    func setDefaultLanguage() {
        // need to set default lanague
        var language: String = NSLocale.preferredLanguages[0]
        var locale: String = ""
        if !supportedLanguages.contains(language) {
            language = LANGUAGE_ENGLISH_CODE
            locale = LANGUAGE_ENGLISH_LOCALE_CODE
        }
        else {
            if (language == LANGUAGE_SPANISH_CODE) {
                language = LANGUAGE_SPANISH_CODE
                locale = LANGUAGE_SPANISH_LOCALE_CODE
            }
            else {
                language = LANGUAGE_ENGLISH_CODE
                locale = LANGUAGE_ENGLISH_LOCALE_CODE
            }
        }
        self.setLanguageInUserDefaultsWithLangaueCode(language: language, withLocaleCode: locale)
    }
    
    func setLanguageAsEnglish() {
        self.setUserPerferedLanguage(language: LANGUAGE_ENGLISH_CODE, withLocale: LANGUAGE_ENGLISH_LOCALE_CODE)
    }
    
    class func setLanguageAsSpanish() {
        self.setUserPerferedLanguage(language: LANGUAGE_SPANISH_CODE, withLocale: LANGUAGE_SPANISH_LOCALE_CODE)
    }
    
    func getPerferedLanguage() -> String {
        let defaults: UserDefaults = UserDefaults.standard
        var value = defaults.object(forKey: kUserPreferedLanguageKey)
        if(value == nil)
        {
            value = ""
        }
        return value as! String
    }
    
    func getPerferedLocaleCode() -> String {
        let defaults: UserDefaults = UserDefaults.standard
        var value = defaults.object(forKey: kUserPreferedLocaleKey)
        if(value == nil)
        {
            value = ""
        }
        return value as! String
    }
    
    func getPerferedLocale() -> NSLocale {
        let defaults: UserDefaults = UserDefaults.standard
        let isoIdentifier: String = (defaults.object(forKey: kUserPreferedLocaleKey) as? String)!
        return NSLocale(localeIdentifier: isoIdentifier)
    }
    
    func getPerferedLanguageForServer() -> String {
        let defaults: UserDefaults = UserDefaults.standard
        let arr:Array = (defaults.object(forKey: kUserPreferedLanguageKey) as? NSString)!.components(separatedBy: "-")
        let val: String? = arr.first!;
        if val == nil {
            self.setLanguageWithIntType(language_value: .English)
            return self.getPerferedLanguage()
        }
        else {
            return val!
        }
    }
    
    func getCurrentLocale() -> NSLocale {
        return NSLocale(localeIdentifier: LanguageManager.getPerferedLocaleCode())
    }
    
    func getLocalizeCountryNameWithCode(countryCode: String) -> String {
        let usLocale: NSLocale = self.getCurrentLocale()
        return usLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
    }
    
    func getLocalizeCurrencyNameWithCode(currencyCode: String) -> String {
        let usLocale: NSLocale = self.getCurrentLocale()
        return (usLocale.displayName(forKey: NSLocale.Key.identifier, value: currencyCode)?.capitalized(with: usLocale as Locale))!
    }
    
    func getLocalizeCurrencyName(withCode currencyCode: String) -> String {
        let usLocale: NSLocale = getCurrentLocale()
        return (usLocale.displayName(forKey: NSLocale.Key.identifier, value: currencyCode)?.capitalized(with: usLocale as Locale))!
    }

    
    
    func getPerferedLanguageInInteger() -> LanguageManagerLanguage {
        var language_int_value: LanguageManagerLanguage = .English
        let language: String = self.getPerferedLanguage()
        if (language == LANGUAGE_ENGLISH_CODE) {
            language_int_value = .English
        }
        else if (language == LANGUAGE_SPANISH_CODE) {
            language_int_value = .Spanish
        }
        
        return language_int_value
    }
    
    func nativeLanguageName(forLocale isoIdentifier: String) -> String {
        let locale = NSLocale(localeIdentifier: isoIdentifier)
        return (locale.displayName(forKey: NSLocale.Key.identifier, value: isoIdentifier)?.capitalized(with: locale as Locale))!
    }
    
    func getLocalizedImage(imageName: String) -> UIImage {
        let path = bundle.path(forResource: imageName, ofType: "png")
        return UIImage(contentsOfFile: path!)!
    }
    
    class func isEnglishLanguage() -> Bool {
        return (LanguageManager.getPerferedLanguage() == LANGUAGE_ENGLISH_CODE)
    }
}
