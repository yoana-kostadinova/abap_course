@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Booking projection view'
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZC_RAP_Booking_YK
  as projection on ZI_RAP_Booking_YK as Booking
{
  key BookingUuid,
      TravelUuid,
      @Search.defaultSearchElement: true
      BookingId,
      BookingDate,
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  } }]
      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      CustomerId,
      _Customer.LastName as CustomerName,
      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Carrier', element: 'AirlineID' }}]
      @ObjectModel.text.element: ['CarrierName']
      CarrierId,
      _Carrier.Name      as CarrierName,
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                          additionalBinding: [ { localElement: 'CarrierID',    element: 'AirlineID' },
                                                               { localElement: 'FlightDate',   element: 'FlightDate',   usage: #RESULT},
                                                               { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT },
                                                               { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] } ]
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      CurrencyCode,
      CreatedBy,
      LastChangedBy,
      LocalLastChangedAt,

      /* Associations */

      _Carrier,
      _Connection,
      _Currency,
      _Customer,
      _Flight,
      _Travel : redirected to parent ZC_RAP_Travel_YK
}
