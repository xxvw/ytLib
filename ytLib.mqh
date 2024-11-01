//+------------------------------------------------------------------+
//|                                                        ytLib.mqh |
//|                                                   Yuuto Tokuhara |
//|                     https://www.mql5.com/en/users/yuutotokuhara/ |
//+------------------------------------------------------------------+
#property copyright "Yuuto Tokuhara"
#property link      "https://www.mql5.com/en/users/yuutotokuhara/"

// 移動平均を取得する関数
double YTL_getMA(int period, ENUM_MA_METHOD method, ENUM_TIMEFRAMES tf)
{
  int ma_handle = -1; 
  ma_handle = iMA(_Symbol, tf, period, 0, method, PRICE_CLOSE); 

  double maValue[1]; 

  CopyBuffer(ma_handle, 0, 0, 1, maValue);

  return maValue[0]; 
}

// ボリンジャーバンドの基準線を取得する関数
double YTL_getBB_Base(int period, double sigma, ENUM_TIMEFRAMES tf)
{
  int handle = -1;
  handle = iBands(_Symbol, tf, period, 0, sigma, PRICE_CLOSE);

  double bandValue[1]; 

  CopyBuffer(handle, 0, 0, 1, bandValue);

  return bandValue[0]; 
}

// ボリンジャーバンドの上限を取得する関数
double YTL_getBB_Upper(int period, double sigma, ENUM_TIMEFRAMES tf)
{
  int handle = -1;
  handle = iBands(_Symbol, tf, period, 0, sigma, PRICE_CLOSE);

  double bandValue[1];

  CopyBuffer(handle, 1, 0, 1, bandValue);

  return bandValue[0]; 
}

// ボリンジャーバンドの下限を取得する関数
double YTL_getBB_Lower(int period, double sigma, ENUM_TIMEFRAMES tf)
{
  int handle = -1;
  handle = iBands(_Symbol, tf, period, 0, sigma, PRICE_CLOSE);

  double bandValue[1]; 

  CopyBuffer(handle, 2, 0, 1, bandValue);

  return bandValue[0]; 
}
