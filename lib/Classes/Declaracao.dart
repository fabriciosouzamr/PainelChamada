class Declaracao {
  static String sistema_IPI_API = '';

  static void configuracao()
  {
    if ( isInDebugMode)
      {
        sistema_IPI_API = '60880503bb28.sn.mynetname.net:8085';
      }
    else
      {
        sistema_IPI_API = '60880503bb28.sn.mynetname.net:8085';
      }
  }

  static String api_address(String endPoint)
  {
    String sAPI = '';

    configuracao();

    sAPI = 'http://' + sistema_IPI_API + '/Cli28JulhoAPI/api/' + endPoint;

    return sAPI;
  }

  static bool get isInDebugMode
  {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
