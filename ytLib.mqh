//+------------------------------------------------------------------+
//|                                                        ytLib.mqh |
//|                                                   Yuuto Tokuhara |
//|                     https://www.mql5.com/en/users/yuutotokuhara/ |
//+------------------------------------------------------------------+
#property copyright "Yuuto Tokuhara"
#property link      "https://www.mql5.com/en/users/yuutotokuhara/"

#include <Trade\Trade.mqh>
CTrade ytLctrade;

// 移動平均を取得する関数
double YTL_getMA(int period, ENUM_MA_METHOD method, ENUM_TIMEFRAMES tf, int shift = 0)
{
  int ma_handle = -1; 
  ma_handle = iMA(_Symbol, tf, period, 0, method, PRICE_CLOSE); 

  double maValue[1]; 

  CopyBuffer(ma_handle, 0, shift, 1, maValue);

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

void YTL_setTpForAll(long magic, ENUM_POSITION_TYPE side, double price)
  {
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
     if("" != PositionGetSymbol(i))
        {
         if(PositionGetInteger(POSITION_TYPE)==side)
           {
            if(Symbol()==PositionGetString(POSITION_SYMBOL))
              {
               if(PositionGetInteger(POSITION_MAGIC)==magic)
                 {
                  Print("Modify TP ", price);
                  bool s = ytLctrade.PositionModify(PositionGetTicket(i), PositionGetDouble(POSITION_SL), price);
                  Print("Modify TP(#", PositionGetTicket(i), ")=> ", s);
                  if (s == false) {Print("Err: ", GetLastError());}
                 }
              }
           }
        }
     }
  }

void YTL_setSlForAll(long magic, ENUM_POSITION_TYPE side, double price)
  {
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
     if("" != PositionGetSymbol(i))
        {
         if(PositionGetInteger(POSITION_TYPE)==side)
           {
            if(Symbol()==PositionGetString(POSITION_SYMBOL))
              {
               if(PositionGetInteger(POSITION_MAGIC)==magic)
                 {
                  Print("Modify SL ", price);
                  bool s = ytLctrade.PositionModify(PositionGetTicket(i), price, PositionGetDouble(POSITION_TP));
                  Print("Modify SL(#", PositionGetTicket(i), ")=> ", s);
                  if (s == false) {Print("Err: ", GetLastError());}
                 }
              }
           }
        }
     }
  }

int YTL_getPositions(long magic, ENUM_POSITION_TYPE side)
  {
   int count =0;
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
     if("" != PositionGetSymbol(i))
        {
         if(PositionGetInteger(POSITION_TYPE)==side)
           {
            if(Symbol()==PositionGetString(POSITION_SYMBOL))
              {
               if(PositionGetInteger(POSITION_MAGIC)==magic)
                 {
                  count++;
                 }
              }
           }
        }
     }
   return count ;
  }

int YTL_getOrders(long magic, ENUM_ORDER_TYPE ot)
  {
   int count =0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(OrderGetTicket(i)))
        {
         if(Symbol()==OrderGetString(ORDER_SYMBOL))
           {
            if(OrderGetInteger(ORDER_MAGIC)==magic)
              {
               long orderType = OrderGetInteger(ORDER_TYPE);
               if(ot == orderType)  // ここで成行注文のみをチェック
                 {
                  count++;
                 }
              }
           }
        }
     }


   return count ;
  }
 
int YTL_deleteOrders(long magic, ENUM_ORDER_TYPE ot)
  {
   int count =0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(OrderGetTicket(i)))
        {
         if(Symbol()==OrderGetString(ORDER_SYMBOL))
           {
            if(OrderGetInteger(ORDER_MAGIC)==magic)
              {
               long orderType = OrderGetInteger(ORDER_TYPE);
               if(ot == orderType)  // ここで成行注文のみをチェック
                 {
                  ytLctrade.OrderDelete(OrderGetTicket(i));
                 }
              }
           }
        }
     }


   return count ;
  }
  
  
double YTL_getAvgPrice(long magic, ENUM_POSITION_TYPE side)
{
   double lots_sum = 0;
   double price_sum = 0;
   double average_price = 0;
   
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      if("" != PositionGetSymbol(i))
      {
         if(PositionGetInteger(POSITION_TYPE)==side)
         {
            if(Symbol()==PositionGetString(POSITION_SYMBOL))
            {
               if(PositionGetInteger(POSITION_MAGIC)==magic)
               {
                  lots_sum += PositionGetDouble(POSITION_VOLUME);
                  price_sum += PositionGetDouble(POSITION_PRICE_OPEN) * PositionGetDouble(POSITION_VOLUME);
               }
            }
         }
      }
   }
   
   if(lots_sum > 0)
   {
      average_price = price_sum / lots_sum;
   }

   return NormalizeDouble(average_price, _Digits);
}

double YTL_getLastPrice(long magic, ENUM_ORDER_TYPE side)
  {
   double lastEntryPrice = 0;
   long lastEntryTime = 0;
   long entryTime = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if("" != PositionGetSymbol(i))
        {
         if(PositionGetInteger(POSITION_TYPE) == side)
           {
            if(Symbol() == PositionGetString(POSITION_SYMBOL))
              {
               if(PositionGetInteger(POSITION_MAGIC) == magic)
                 {
                  entryTime = PositionGetInteger(POSITION_TIME);
                  if(entryTime > lastEntryTime)
                    {
                     lastEntryTime = entryTime;
                     lastEntryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
                    }
                 }
              }
           }
        }
     }

   return lastEntryPrice;
  }
 
