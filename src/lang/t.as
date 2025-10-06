package lang {

  /**
   * @param key The translation key
   * @return Localized string
   */
  [Inline]
  public function t(key:String):String {
    return Lang.getText(key);
  }
}
