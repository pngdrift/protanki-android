package lang {

  /**
   * @param key The translation key
   * @return Localized string
   */
  public function t(key:String):String {
    return Lang.getText(key);
  }
}
